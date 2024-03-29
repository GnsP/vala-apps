namespace Emendo {
public class Apply: GLib.Object {
    // 1. Editor
    public void set_font() {
        for (int i = 0; i < files.length(); i++) {
            var tabs = new Emendo.Tabs();
            var view = tabs.get_sourceview_at_tab(i);
            view.override_font(Pango.FontDescription.from_string(font));
        }
    }

    public void set_scheme() {
        var style_manager = new Gtk.SourceStyleSchemeManager();
        var style_scheme = style_manager.get_scheme(scheme);
        for (int i = 0; i < files.length(); i++) {
            var tabs = new Emendo.Tabs();
            var view = tabs.get_sourceview_at_tab(i);
            var buffer = (Gtk.SourceBuffer) view.get_buffer();
            buffer.set_style_scheme(style_scheme);
        }
    }

    public void set_margin_pos() {
        for (int i = 0; i < files.length(); i++) {
            var tabs = new Emendo.Tabs();
            var view = tabs.get_sourceview_at_tab(i);
            view.set_right_margin_position(margin_pos);
        }
    }

    public void set_indent_size() {
        for (int i = 0; i < files.length(); i++) {
            var tabs = new Emendo.Tabs();
            var view = tabs.get_sourceview_at_tab(i);
            view.set_indent_width(indent_size);
        }
    }

    public void set_tab_size() {
        for (int i = 0; i < files.length(); i++) {
            var tabs = new Emendo.Tabs();
            var view = tabs.get_sourceview_at_tab(i);
            view.set_tab_width(tab_size);
        }
    }

    // 2. View
    public void set_numbers_show() {
        for (int i = 0; i < files.length(); i++) {
            var tabs = new Emendo.Tabs();
            var view = tabs.get_sourceview_at_tab(i);
            view.set_show_line_numbers(numbers_show);
        }
    }

    public void set_highlight() {
        for (int i = 0; i < files.length(); i++) {
            var tabs = new Emendo.Tabs();
            var view = tabs.get_sourceview_at_tab(i);
            view.set_highlight_current_line(highlight);
        }
    }

    public void set_margin_show() {
        for (int i = 0; i < files.length(); i++) {
            var tabs = new Emendo.Tabs();
            var view = tabs.get_sourceview_at_tab(i);
            view.set_show_right_margin(margin_show);
        }
    }

    public void set_spaces() {
        for (int i = 0; i < files.length(); i++) {
            var tabs = new Emendo.Tabs();
            var view = tabs.get_sourceview_at_tab(i);
            view.set_insert_spaces_instead_of_tabs(spaces);
        }
    }

    public void set_auto_indent() {
        for (int i = 0; i < files.length(); i++) {
            var tabs = new Emendo.Tabs();
            var view = tabs.get_sourceview_at_tab(i);
            view.set_auto_indent(auto_indent);
        }
    }
}
}
