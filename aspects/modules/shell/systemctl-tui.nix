{
  tack.inputs.systemctl-tui = {
    url = "gh:rgwood/systemctl-tui";
    type = "fetch";
  };

  perSystem =
    { inputs, pkgs, ... }:
    {
      packages.systemctl-tui = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "systemctl-tui";
        meta.mainProgram = finalAttrs.pname;
        version = "0.8.0";
        src = inputs.systemctl-tui;
        cargoLock.lockFile = finalAttrs.src + "/Cargo.lock";
        doCheck = false;
        cargoBuildFlags = [
          "--config"
          "profile.release.strip=true"
        ];
        postInstall = "ln -s $out/bin/systemctl-tui $out/bin/sct";
        patches = [
          (pkgs.writeText "systemctl-tui-sharp-border-patch" /* rust */ ''
            diff --git a/crates/systemctl-tui/src/components/home.rs b/crates/systemctl-tui/src/components/home.rs
            index 4787c78..3cb1215 100644
            --- a/crates/systemctl-tui/src/components/home.rs
            +++ b/crates/systemctl-tui/src/components/home.rs
            @@ -2071,7 +2071,7 @@ impl Component for Home {
                   .block(
                     Block::default()
                       .borders(Borders::ALL)
            -          .border_type(BorderType::Rounded)
            +          .border_type(BorderType::Plain)
                       .border_style(if self.mode == Mode::ServiceList {
                         Style::default().fg(theme.accent)
                       } else {
            @@ -2285,7 +2285,7 @@ impl Component for Home {
                 let logs_panel = right_panel[1];
             
                 let details_block =
            -      Block::default().title(block_title("Details")).borders(Borders::ALL).border_type(BorderType::Rounded);
            +      Block::default().title(block_title("Details")).borders(Borders::ALL).border_type(BorderType::Plain);
                 let details_inner = details_block.inner(details_panel);
                 f.render_widget(details_block, details_panel);
             
            @@ -2441,7 +2441,7 @@ impl Component for Home {
                     Block::default()
                       .title(block_title(format!("Logs — {logs_unit} [{order_label}; ctrl+r to reverse]")))
                       .borders(Borders::ALL)
            -          .border_type(BorderType::Rounded),
            +          .border_type(BorderType::Plain),
                   )
                   .style(Style::default())
                   .wrap(Wrap { trim: true });
            @@ -2529,7 +2529,7 @@ impl Component for Home {
                     _ => Style::default(),
                   })
                   .scroll((0, scroll as u16))
            -      .block(Block::default().borders(Borders::ALL).border_type(BorderType::Rounded).title(block_title(Line::from(
            +      .block(Block::default().borders(Borders::ALL).border_type(BorderType::Plain).title(block_title(Line::from(
                     vec![
                       Span::raw("Search "),
                       Span::styled("(", Style::default().fg(theme.muted_alt)),
            @@ -2592,7 +2592,7 @@ impl Component for Home {
                   let title = format!("Help for {name} v{version}");
             
                   let paragraph = Paragraph::new(help_lines)
            -        .block(Block::default().title(block_title(title)).borders(Borders::ALL).border_type(BorderType::Rounded))
            +        .block(Block::default().title(block_title(title)).borders(Borders::ALL).border_type(BorderType::Plain))
                     .style(Style::default())
                     .wrap(Wrap { trim: true });
             
            @@ -2608,7 +2608,7 @@ impl Component for Home {
                       Block::default()
                         .title(block_title("Error"))
                         .borders(Borders::ALL)
            -            .border_type(BorderType::Rounded)
            +            .border_type(BorderType::Plain)
                         .border_style(Style::default().fg(Color::Red)),
                     )
                     .wrap(Wrap { trim: true });
            @@ -2645,7 +2645,7 @@ impl Component for Home {
                       Block::default()
                         .title(block_title(title))
                         .borders(Borders::ALL)
            -            .border_type(BorderType::Rounded)
            +            .border_type(BorderType::Plain)
                         .border_style(Style::default().fg(theme.accent))
                         .padding(ratatui::widgets::Padding::horizontal(1)),
                     )
            @@ -2764,7 +2764,7 @@ impl Component for Home {
                   let paragraph = Paragraph::new(lines).block(
                     Block::default()
                       .borders(Borders::ALL)
            -          .border_type(BorderType::Rounded)
            +          .border_type(BorderType::Plain)
                       .border_style(Style::default().fg(theme.accent))
                       .title(block_title("Unit filters")),
                   );
            @@ -2840,7 +2840,7 @@ impl Component for Home {
             
                   let outer = Block::default()
                     .borders(Borders::ALL)
            -        .border_type(BorderType::Rounded)
            +        .border_type(BorderType::Plain)
                     .border_style(Style::default().fg(theme.accent))
                     .title(block_title("All commands"));
                   f.render_widget(Clear, popup);
            @@ -2852,7 +2852,7 @@ impl Component for Home {
                   let search_width = search_rect.width.saturating_sub(2).max(1);
                   let scroll = self.command_input.visual_scroll(search_width as usize);
                   let search = Paragraph::new(self.command_input.value()).scroll((0, scroll as u16)).block(
            -        Block::default().borders(Borders::ALL).border_type(BorderType::Rounded).title(block_title("Search commands")),
            +        Block::default().borders(Borders::ALL).border_type(BorderType::Plain).title(block_title("Search commands")),
                   );
                   f.render_widget(search, search_rect);
             
            @@ -2904,7 +2904,7 @@ impl Component for Home {
                     .block(
                       Block::default()
                         .borders(Borders::ALL)
            -            .border_type(BorderType::Rounded)
            +            .border_type(BorderType::Plain)
                         .border_style(Style::default().fg(theme.accent))
                         .title(block_title(title)),
                     )
            @@ -2939,7 +2939,7 @@ impl Component for Home {
                     .block(
                       Block::default()
                         .title(block_title("Processing"))
            -            .border_type(BorderType::Rounded)
            +            .border_type(BorderType::Plain)
                         .borders(Borders::ALL)
                         .border_style(Style::default().fg(theme.accent)),
                     )
            diff --git a/crates/systemctl-tui/src/components/logger.rs b/crates/systemctl-tui/src/components/logger.rs
            index f58152c..fe6527d 100644
            --- a/crates/systemctl-tui/src/components/logger.rs
            +++ b/crates/systemctl-tui/src/components/logger.rs
            @@ -28,7 +28,7 @@ impl Component for Logger {
                     Block::default()
                       .title(block_title("systemctl-tui logs"))
                       .borders(Borders::ALL)
            -          .border_type(BorderType::Rounded),
            +          .border_type(BorderType::Plain),
                   )
                   .style_error(Style::default().fg(Color::Red))
                   .style_debug(Style::default().fg(Color::Green))
          '')
        ];
      });
    };

  exo.core =
    { self', ... }:
    {
      hj.packages = [ self'.packages.systemctl-tui ];

      my.xdg.desktopTuiEntries."sct" = {
        package = self'.packages.systemctl-tui;
        width = 2100;
        height = 1200;
      };
    };
}
