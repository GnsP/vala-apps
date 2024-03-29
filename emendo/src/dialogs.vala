namespace Emendo {
public class Dialogs: Gtk.Dialog {
    public void show_open() {
        string selected;
        var dialog = new Gtk.FileChooserDialog(_("Open"), window,
                                               Gtk.FileChooserAction.OPEN,
                                               _("Cancel"), Gtk.ResponseType.CANCEL,
                                               _("Open"),   Gtk.ResponseType.ACCEPT);
        if (notebook.get_n_pages() > 0) {
            var tabs = new Emendo.Tabs();
            string cf = tabs.get_current_path();
            dialog.set_current_folder(Path.get_dirname(cf));
        }
        dialog.set_select_multiple(false);
        dialog.set_modal(true);
        dialog.show();
        if (dialog.run() == Gtk.ResponseType.ACCEPT) {
            selected = dialog.get_filename();
            var nbook = new Emendo.NBook();
            var operations = new Emendo.Operations();
            nbook.create_tab(selected);
            operations.open_file(selected);
        }
        dialog.destroy();
    }

    public void show_save() {
        if (notebook.get_n_pages() == 0) {
            return;
        }
        string newname;
        var dialog = new Gtk.FileChooserDialog(_("Save As..."), window,
                                               Gtk.FileChooserAction.SAVE,
                                               _("Cancel"), Gtk.ResponseType.CANCEL,
                                               _("Save"),   Gtk.ResponseType.ACCEPT);
        var tabs = new Emendo.Tabs();
        string cf = tabs.get_current_path();
        dialog.set_current_folder(Path.get_dirname(cf));
        dialog.set_current_name(Path.get_basename(cf));
        dialog.set_do_overwrite_confirmation(true);
        dialog.set_modal(true);
        dialog.show();
        if (dialog.run() == Gtk.ResponseType.ACCEPT) {
            newname = dialog.get_filename();
            var operations = new Emendo.Operations();
            operations.save_file_as(newname);
        }
        dialog.destroy();
    }

    public void save_fallback(string path) {
        var dialog = new Gtk.MessageDialog( window,
                                            Gtk.DialogFlags.MODAL, Gtk.MessageType.ERROR, Gtk.ButtonsType.NONE,
                                            _("Error saving file %s.\nThe file on disk may now be truncated!"), path);
        dialog.add_button(_("Close Without Saving"), Gtk.ResponseType.NO);
        dialog.add_button(_("Select New Location"),  Gtk.ResponseType.YES);
        dialog.set_resizable(false);
        dialog.set_title(_("Error"));
        dialog.set_default_response(Gtk.ResponseType.YES);
        int response = dialog.run();
        switch (response) {
        case Gtk.ResponseType.NO:
            break;
        case Gtk.ResponseType.YES:
            show_save();
            break;
        }
        dialog.destroy();
    }

    public void show_about() {
        var about = new Gtk.AboutDialog();
        about.set_program_name(NAME);
        about.set_version(VERSION);
        about.set_comments(DESCRIPTION);
        about.set_logo_icon_name(ICON);
        about.set_icon_name(ICON);
        about.set_authors(AUTHORS);
        about.set_copyright("Copyright \xc2\xa9 2015");
        about.set_website("https://github.com/simargl");
        about.set_property("skip-taskbar-hint", true);
        about.set_transient_for(window);
        about.license_type = Gtk.License.GPL_3_0;
        about.run();
        about.hide();
    }

    public void changes_one(int num, string path) {
        var dialog = new Gtk.MessageDialog( window,
                                            Gtk.DialogFlags.MODAL, Gtk.MessageType.QUESTION, Gtk.ButtonsType.NONE,
                                            _("The file '%s' is not saved.\nDo you want to save it before closing?"), path);
        dialog.add_button(_("Close Without Saving"), Gtk.ResponseType.NO);
        dialog.add_button(_("Cancel"), Gtk.ResponseType.CANCEL);
        dialog.add_button(_("Save"),  Gtk.ResponseType.YES);
        dialog.set_resizable(false);
        dialog.set_title(_("Question"));
        dialog.set_default_response(Gtk.ResponseType.YES);
        int response = dialog.run();
        switch (response) {
        case Gtk.ResponseType.NO:
            notebook.remove_page(num);
            unowned List<string> del_item = files.find_custom (path, strcmp);
            files.remove_link(del_item);
            if (notebook.get_n_pages() == 0) {
                window.set_title("");
            }
            break;
        case Gtk.ResponseType.CANCEL:
            break;
        case Gtk.ResponseType.YES:
            var operations = new Emendo.Operations();
            operations.save_file_at_pos(num);
            notebook.remove_page(num);
            unowned List<string> del_item = files.find_custom (path, strcmp);
            files.remove_link(del_item);
            if (notebook.get_n_pages() == 0) {
                window.set_title("");
            }
            break;
        }
        dialog.destroy();
    }

    public void changes_all() {
        var settings = new Emendo.Settings();
        settings.set_recent_files();
        for (int i = (int)files.length() - 1; i >= 0; i--) {
            var tabs = new Emendo.Tabs();
            string path = tabs.get_path_at_tab(i);
            var view = tabs.get_sourceview_at_tab(i);
            var buffer = (Gtk.SourceBuffer) view.get_buffer();
            if (buffer.get_modified() == false) {
                notebook.remove_page(i);
                unowned List<string> del_item = files.find_custom (path, strcmp);
                files.remove_link(del_item);
            } else {
                var dialogs = new Emendo.Dialogs();
                dialogs.changes_one(i, path);
            }
        }
        if (notebook.get_n_pages() == 0) {
            var mainwin = new Emendo.MainWin();
            mainwin.action_app_quit();
        }
    }

}
}
