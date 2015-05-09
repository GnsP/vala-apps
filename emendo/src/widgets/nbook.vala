namespace Emendo
{
public class NBook: Gtk.Notebook
{
    public void create_tab(string path)
    {
        if (files.contains(path) == true)
        {
            int i;
            for (i = 0; i < files.size; i++)
            {
                if (files[i] == path)
                    notebook.set_current_page(i);
            }
            print("debug: refusing to add %s again\n", path);
            return;
        }

        // Page
        var tab_view = new Gtk.SourceView();
        // from settings
        tab_view.override_font(Pango.FontDescription.from_string(font));
        tab_view.set_right_margin_position(margin_pos);
        tab_view.set_indent_width(indent_size);
        tab_view.set_tab_width(tab_size);
        tab_view.set_show_line_numbers(numbers_show);
        tab_view.set_highlight_current_line(highlight);
        tab_view.set_show_right_margin(margin_show);
        tab_view.set_insert_spaces_instead_of_tabs(spaces);
        tab_view.set_auto_indent(auto_indent);

        // default
        tab_view.set_cursor_visible(true);
        tab_view.set_left_margin(10);

        // style scheme
        var style_manager = new Gtk.SourceStyleSchemeManager();
        var style_scheme  = style_manager.get_scheme(scheme);
        var buffer = (Gtk.SourceBuffer) tab_view.get_buffer();
        buffer.set_style_scheme(style_scheme);

        var tab_page = new Gtk.ScrolledWindow(null, null);
        tab_page.add(tab_view);
        tab_page.show_all();

        // Tab
        var tab_label = new Gtk.Label(GLib.Path.get_basename(path));
        tab_label.set_tooltip_text(path);
        tab_label.expand = true;
        var eventbox = new Gtk.EventBox();
        eventbox.add(tab_label);
        // Close tab with middle click
        eventbox.button_press_event.connect((event) =>
        {
            if (event.button == 2)
                destroy_tab(tab_page, path);
            return false;
        });

        var tab_button = new Gtk.Button.from_icon_name("window-close-symbolic", Gtk.IconSize.MENU);
        tab_button.set_relief(Gtk.ReliefStyle.NONE);
        tab_button.clicked.connect(() =>
        {
            destroy_tab(tab_page, path);
        });

        var tab = new Gtk.Grid();
        tab.attach(eventbox,   0, 0, 1, 1);
        tab.attach(tab_button, 1, 0, 1, 1);
        tab.set_column_spacing(10);
        tab.show_all();

        files.add(path);
        print("debug: added %s\n", path);
        current_files();

        // Add tab and page to notebook
        notebook.append_page(tab_page, tab);
        notebook.set_current_page(notebook.get_n_pages() - 1);
        notebook.show_all();

        if (notebook.get_n_pages() == 1)
            notebook.set_show_tabs(false);
        else
            notebook.set_show_tabs(true);
        tab_view.grab_focus();

        buffer.modified_changed.connect(() =>
        {
            on_modified_changed(buffer, tab_label, path);
        });
    }

    // Destroy tab
    public void destroy_tab(Gtk.Widget page, string path)
    {
        int page_num = notebook.page_num(page);

        var tabs = new Emendo.Tabs();
        var view = tabs.get_sourceview_at_tab(page_num);
        var buffer = (Gtk.SourceBuffer) view.get_buffer();

        if (buffer.get_modified() == true)
        {
            var dialogs = new Emendo.Dialogs();
            dialogs.changes_one(page_num, path);
        }
        else
        {
            notebook.remove_page(page_num);
            files.remove(path);
            current_files();
            if (notebook.get_n_pages() == 0)
                headerbar.set_title(NAME);
            if (notebook.get_n_pages() == 1)
                notebook.set_show_tabs(false);
            else
                notebook.set_show_tabs(true);
        }
    }

    // Update label on modified buffer
    public void on_modified_changed(Gtk.SourceBuffer bf, Gtk.Label lab, string p)
    {
        if (bf.get_modified() == true)
            lab.set_text(GLib.Path.get_basename(p) + " *");
        else
            lab.set_text(GLib.Path.get_basename(p));
    }

    public void current_files()
    {
        print("%s\n", "debug: list");
        foreach(string i in files)
        print("  %s\n", i);
        print("\n\n");
    }
}
}