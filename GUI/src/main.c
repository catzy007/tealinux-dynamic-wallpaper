#include <gtk/gtk.h>
//https://prognotes.net/2016/03/gtk-3-c-code-hello-world-tutorial-using-glade-3/

//if you want home, then remove `~` at begining of path
//system will replace that with `/home/activeuser`
char configfile[]="/.config/status-dynamic-wallpaper.cfg"; //change this line
char dynWpBash[]="/bin/bash /usr/share/tealinux/dynamic-wallpaper/dynamic-wallpaper.sh &";
char killCommand[]="pkill -u $(whoami) -f /usr/share/tealinux/dynamic-wallpaper/dynamic-wallpaper.sh";

void getHome(char *input, char *output){
    char buffer[255];
    FILE* file = popen("echo $HOME", "r");
    fscanf(file, "%100s", buffer);
    pclose(file);
    strcpy(output,buffer);
    strcat(output,input);
    //printf("%s\n", buffer);
}

int getDynWpStatus(char *pathfile){
    int mark=0;
    char text[2];
    FILE *file1;

    file1=fopen(pathfile,"r");
    while(fgets(text,sizeof(text),file1)!= NULL){
        if(strcmp(text,"1")==0){
            mark=1;
        }
    }
    printf("%s\n",text);
    fclose(file1);

    return mark;
}

//pointer to button0
GtkWidget *g_Button0;

int main(int argc, char *argv[])
{
    GtkBuilder      *builder;
    GtkWidget       *window;

    gtk_init(&argc, &argv);

    builder = gtk_builder_new();
    gtk_builder_add_from_file (builder, "glade/window_main.glade", NULL);

    window = GTK_WIDGET(gtk_builder_get_object(builder, "MainWIndow"));
    gtk_builder_connect_signals(builder, NULL);

    //connect pointer to button0
    g_Button0 = GTK_WIDGET(gtk_builder_get_object(builder,"Button0"));

    char pathfile[255];
    getHome(configfile,pathfile);
    if(getDynWpStatus(pathfile)==1){
        gtk_button_set_label(GTK_BUTTON(g_Button0),"Disable");
    }else{
        gtk_button_set_label(GTK_BUTTON(g_Button0),"Enable");
    }

    g_object_unref(builder);

    gtk_widget_show(window);
    gtk_main();

    return 0;
}

// called when window is closed
void on_window_main_destroy()
{
    gtk_main_quit();
}

//call function when Button0 is clicked
void on_Button_clicked(){
    char commd[255]; char pathfile[255];
    getHome(configfile,pathfile);
    //printf("%s",pathfile);

    if(getDynWpStatus(pathfile)==1){
        gtk_button_set_label(GTK_BUTTON(g_Button0),"Enable");
        system(killCommand);
        strcpy(commd,"echo 0 > ");
        strcat(commd,pathfile);
        system(commd);
    }else{
        gtk_button_set_label(GTK_BUTTON(g_Button0),"Disable");
        strcpy(commd,"echo 1 > ");
        strcat(commd,pathfile);
        system(commd);
        system(dynWpBash);
    }
    printf("%s\n",commd);
}
