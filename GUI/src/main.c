#include <gtk/gtk.h>
//https://prognotes.net/2016/03/gtk-3-c-code-hello-world-tutorial-using-glade-3/

//if you want home, then remove `~` at begining of path
//system will replace that with `/home/activeuser`
char configfile[]="/.config/status-dynamic-wallpaper.cfg";
char configLocation[]="/.config/location-dynamic-wallpaper.cfg";
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

gboolean on_widget_deleted(GtkWidget *widget, GdkEvent *event, gpointer data)
{
    gtk_widget_hide(widget);
    return TRUE;
}

//pointer to gtk wiget
GtkWidget *g_StrIpt1;
GtkWidget *g_StrIpt2;
GtkWidget *g_Button0;
GtkWidget *g_Button1;
GtkWidget *g_windowConfig;

int main(int argc, char *argv[]){
    GtkBuilder      *builder;
    GtkWidget       *window;

    gtk_init(&argc, &argv);

    builder = gtk_builder_new();
    gtk_builder_add_from_file (builder, "glade/window_main.glade", NULL);

    //create window
    window = GTK_WIDGET(gtk_builder_get_object(builder, "MainWIndow"));
    g_windowConfig = GTK_WIDGET(gtk_builder_get_object(builder, "ConfigWindow"));
    gtk_builder_connect_signals(builder, NULL);

    //connect pointer to test input
    g_StrIpt1 = GTK_WIDGET(gtk_builder_get_object(builder,"IptCity"));
	g_StrIpt2 = GTK_WIDGET(gtk_builder_get_object(builder,"IptCountry"));

    //connect pointer to button
    g_Button0 = GTK_WIDGET(gtk_builder_get_object(builder,"Button0"));
    g_Button1 = GTK_WIDGET(gtk_builder_get_object(builder,"Button1"));

    //signal to avoid close button destroying window
    g_signal_connect(G_OBJECT(g_windowConfig), "delete-event", G_CALLBACK(on_widget_deleted), NULL);

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
void on_window_main_destroy(){
    gtk_main_quit();
}

//call function when Button0 is clicked
void on_Button_clicked(){
    char commd[255]; char pathfile[255];
    getHome(configfile,pathfile);
    printf("%s",pathfile);

    if(getDynWpStatus(pathfile)==1){
        gtk_button_set_label(GTK_BUTTON(g_Button0),"Enable");
        system(killCommand);
        strcpy(commd,"echo 0 > ");
        strcat(commd,pathfile);
        system(commd);
    }else{
        gtk_button_set_label(GTK_BUTTON(g_Button0),"Disable");
        system(dynWpBash);
        strcpy(commd,"echo 1 > ");
        strcat(commd,pathfile);
        system(commd);
    }
     printf("%s\n",commd);
}

void on_BtnCfg_clicked(){
    gtk_widget_show(g_windowConfig);
}

void on_Submit_clicked(){
    char commd[255]; char pathfile[255];
    getHome(configLocation,pathfile);
    //printf("%s\n",pathfile);
    
    const gchar *txtCity=gtk_entry_get_text(GTK_ENTRY(g_StrIpt1));
    const gchar *txtCountry=gtk_entry_get_text(GTK_ENTRY(g_StrIpt2));
    if(txtCity[0] != '\0' && txtCountry[0] != '\0'){
        //printf("%s %s\n", txtCity, txtCountry);
        strcpy(commd,"echo ");
        strcat(commd,txtCity);
        strcat(commd," > ");
        strcat(commd,pathfile);
        //printf("%s\n",commd);
        system(commd);

        strcpy(commd,"echo ");
        strcat(commd,txtCountry);
        strcat(commd," >> ");
        strcat(commd,pathfile);
        //printf("%s\n",commd);
        system(commd);
    }
}