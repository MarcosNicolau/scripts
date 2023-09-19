/*
---------------------------------------------------------------
    A SCRIPT TO SAVE IN PROJECT ZOMBOID
---------------------------------------------------------------
*/

#include <iostream>
#include <filesystem>
#include <getopt.h>

using namespace std;
namespace fs = filesystem;

const string ENV_DEFAULT_SAVES_PATH = "ZOMBOID_SAVES";
const string USER = "USER";

// Removes the path from a string
string base_name(string const &path)
{
    return path.substr(path.find_last_of("/\\") + 1);
}

// Removes a file extension
string remove_ext(string filename)
{
    return filename.substr(0, filename.find_last_of("."));
}

string get_file_directory(string path)
{
    return path.substr(0, path.find_last_of("/\\"));
}

string get_default_saves_path()
{
    char *theme = getenv(ENV_DEFAULT_SAVES_PATH.c_str());
    char *user = getenv(USER.c_str());
    return theme == NULL ? ("/home/" + string(user) + "/Zomboid/Saves/") : string(theme);
}

string build_path(string dir, string file)
{
    return dir + "/" + file;
}

void show_help()
{

    cout << "This script will restart a save your zomboid fie, it has autocompletion (press <TAB>) so you don't have to remember the file names! \n"
         << endl;
    cout << "Usage: zomboid [OPTIONS] <SAVE_FILE>" << endl
         << endl;
    cout << "OPTIONS:" << endl;
    cout << "       --as         The name of the new save. If not provided, defaults to: <SAVE_FILE> (<INDEX>)" << endl;
    cout << "   -o, --overwrite  If you want to overwrite you current save with the current one" << endl
         << endl;

    cout << "By default the program expects that saves are located in:  ~/Zomboid/Saves/Sandbox" << endl;
    cout << "To change this behaviour set the env variable ZOMBOID_SAVES to your location, like so: export ZOMBOID_SAVES=<YOUR_PATH>" << endl;
}

string generate_file_name(string file)
{
    int index = 1;
    for (const auto &entry : fs::directory_iterator(build_path(get_default_saves_path(), get_file_directory(file))))
    {
        string name = base_name(entry.path());
        string file_name = base_name(file);
        if (name.find(file_name, 0) == std::string::npos)
            continue;
        if (file_name == name)
            continue;
        // Saves follow the format: <file_name> (<index>)
        int file_index = stoi(name.substr(file_name.size() + 2, 1));
        if (file_index > index)
            index = file_index;
    }
    return file + " (" + to_string(index + 1) + ")";
}

void save(string file, string save_as)
{
    if (!fs::exists(build_path(get_default_saves_path(), file)))
    {
        cout << "The provided file does not exist! Could not save" << endl;
        exit(1);
    }
    fs::copy(build_path(get_default_saves_path(), file), build_path(get_default_saves_path(), save_as));
}

int main(int argc, char *argv[])
{
    // Available program options
    struct Options
    {
        string save_as = "";
        bool should_overwrite = false;
    } options;

    // Get options
    int c;
    while (c != -1)
    {
        int option_index = 0;
        static struct option long_options[] = {
            {"as", required_argument, 0, 0},
            {"overwrite", required_argument, 0, 'o'},
            {"help", no_argument, 0, 'h'},
            {0, 0, 0},
        };
        c = getopt_long(argc, argv, "1:o:h",
                        long_options, &option_index);
        switch (c)
        {
        case 0:
            options.save_as = optarg;
            break;
        case 'r':
            options.should_overwrite = true;
            break;
        case 'h':
            show_help();
            exit(0);
        // whenever there is an error c = 63
        case 63:
            exit(1);
        }
    }
    // Verify that a markdown file was provided after the options.
    if (optind == argc)
    {
        cout << "You must provide a file in order to save it." << endl;
        cout << "Pass --help or -h for more information about command" << endl;
        exit(1);
    }

    // Get the provided file
    string file = argv[optind++];

    // Default the options if not set
    if (options.save_as.empty())
        options.save_as = options.should_overwrite ? file : generate_file_name(file);
    else
        options.save_as = build_path(get_file_directory(file), options.save_as);
    save(file, options.save_as);
    cout << "Filed saved successfully" << endl;
    exit(0);
}
