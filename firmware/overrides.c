// Remove anything that is not needed

#include "user_io.h"
#include "timer.h"
#include "statusword.h"
#include "minfat.h"
#include "ide.h"
#include "settings.h"
#include "statusword.h"

#include "c64keys.c"

#include <stdio.h>
#include <string.h>

int LoadROM(const char *fn);
 

#define bootrom_name1 "PCXT    ROM"
#define bootrom_name2 "TANDY   ROM"
#define bootrom_name3 "XTIDE   ROM"

#define bootvhd_name1 "PCXT1   VHD"
#define bootvhd_name2 "PCXT2   VHD"

/* 0 and 3 chosen to line up with ROM upload indices. */
#define BLOB_PCXTROM 0
#define BLOB_TANDYROM 1
#define BLOB_XTIDEROM 2
#define BLOB_HDD1 3
#define BLOB_HDD2 4
#define BLOB_COUNT 5

struct pcxt_config
{
	char version;
	char scandouble;
	char pad[2];
	int status;
	struct settings_blob blob[BLOB_COUNT];
};


struct pcxt_config configfile_data={
	0x01,          /* version */
	0x00,          /* scandouble disable */
	0x0,0x0,       /* Pad */
	0x00,          /* Status */
	{
		{              /* ROM 1 dir and filename */
			0x00, bootrom_name1
		},
		{              /* ROM 2 dir and filename */
			0x00, bootrom_name2
		},
		{              /* ROM 3 dir and filename */
			0x00, bootrom_name3
		},
		{              /* HD1 dir and filename */
			0x00, bootvhd_name1
		},
		{              /* HD2 dir and filename */
			0x00, bootvhd_name2
		}
	}
};


const char *rom_filenames[3]={
	bootrom_name1,
	bootrom_name2,
	bootrom_name3
};


int LoadROM(const char *fn);
extern fileTYPE file;
extern unsigned char romtype;

int loadimage(char *filename,int unit)
{
	int result=0;
	switch(unit)
	{
		case 0:
		case 1:
		case 2:
			if(filename && filename[0])
			{
				settings_storeblob(&configfile_data.blob[unit],filename);
				statusword|=1;
				sendstatus();
				romtype=unit+1;
				result=LoadROM(filename);
				if(!result) /* Fallback to default ROM if not found */
				{
					ChangeDirectory(0);
					result=LoadROM(rom_filenames[unit]);
				}
			}
			break;
		case '0':
		case '1':
			settings_storeblob(&configfile_data.blob[BLOB_HDD1+unit-'0'],filename);
			OpenHardfile(filename,unit-'0');
			break;
		case 'S':
			return(loadsettings(filename));
			break;
		case 'T':
			return(savesettings(filename));
			break;
	}
	statusword&=~1;
	sendstatus();
	return(result);
}


int configtocore(char *buf)
{
	struct pcxt_config *dat=(struct pcxt_config *)buf;
	int result=0;

	if(dat->version==1)
	{
		memcpy(&configfile_data,buf,sizeof(configfile_data)); /* Beware - at boot we're copying the default config over itself.  Safe on 832, but undefined behaviour. */
		SetScandouble(configfile_data.scandouble);
		statusword=configfile_data.status;

		result|=settings_loadblob(&configfile_data.blob[BLOB_PCXTROM],0);
		result|=settings_loadblob(&configfile_data.blob[BLOB_TANDYROM],1); /* Consider the load a success if either PCXT ROM or Tandy ROM were loaded */
		settings_loadblob(&configfile_data.blob[BLOB_XTIDEROM],2);

		settings_loadblob(&configfile_data.blob[BLOB_HDD1],'0');
		settings_loadblob(&configfile_data.blob[BLOB_HDD2],'1');
	}
	return(result);
}


void coretoconfig(char *buf)
{
	configfile_data.status=statusword;
	configfile_data.scandouble=GetScandouble();
	memcpy(buf,&configfile_data,sizeof(configfile_data));
}



char *autoboot()
{
	char *result=0;

	if(!loadsettings(CONFIG_SETTINGS_FILENAME))
	{
		if(!(configtocore(&configfile_data.version))) /* Caution - the configfile data is updated in place - with itself! */
			result="No ROM";
	}
	return(result);
}


char *get_rtc();

__weak void mainloop()
{
	int framecounter;
	initc64keys();
	while(1)
	{
		handlec64keys();
		Menu_Run();
		HandleHDD();
		if((framecounter++&8191)==0)
			user_io_send_rtc(get_rtc());
	}
}


