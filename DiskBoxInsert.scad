//
// OpenSCAD file describing a 3" floppy disk insert for Oric tape box, including:
// - A hollow main plate to install inside the case
// - Two clip-on bits designed to restrain the floppy inside the case so it does not move around
//

// Main body of the insert
main_frame      = [81.7,125.2,7];                            // Dimensions of the main box area
frame_thickness = 0.7;
bottom_cut_out  = [74,116,main_frame[2]-frame_thickness];    // Dimensions of the hollowed area under

text_height = 0.3;        // Raised text height (set to frame_thickness to go through)
text_box    = [70,40,1];

frame_color = "#000000";
text_color  = "#e8dbb7";
show_text   = 1;

generate_main_frame();
generate_plug_ins();
generate_logo_text();

module generate_main_frame()
{
    difference() 
    {     
        // The main insert plate
        color(frame_color)
        cube(main_frame);          

        // Hollowed-out Defence Force logo centered on the box
        translate([main_frame[0]/2,main_frame[1]/2,main_frame[2]-text_height])
        framed_text();     
        
        // Removal of the back part
        translate([(main_frame[0] - bottom_cut_out[0]) / 2, (main_frame[1] - bottom_cut_out[1]) / 2, 0])
        cube(bottom_cut_out);

        // Add the three notches (top, bottom and right side)
        notches();         

        // Make the holes for the pegs
        connectors(0);     
    }
}


module generate_logo_text()
{
    translate([main_frame[0]/2,main_frame[1]/2,main_frame[2]-text_height])
    color(text_color)
    framed_text();     
}


module generate_plug_ins()
{
    // Plug-in elements
    top_layer = [main_frame[0], main_frame[1], 5];
    top_cut_out = [top_layer[0], 100, 5];
    cover_ridge_out = [top_layer[0], 2, 5];
    cover_ridge_out2 = [2,top_layer[1], 5];
    peg_clearance = 0.2;  // Clearance for pegs (for fit)

    translate([+100,0,main_frame[2]-top_layer[2]])        // Only necessary when showing the template
    {
        difference() 
        {      
            color(frame_color)
            cube(top_layer);   // Outer box

            translate([0,main_frame[1]-cover_ridge_out[1],0])
            cube(cover_ridge_out);   // Top ridge

            translate([0,0,0])
            cube(cover_ridge_out);   // Bottom ridge

            translate([main_frame[0]-cover_ridge_out2[0],0,0])
            cube(cover_ridge_out2);   // Right side ridge

            notches();         // Add the three notches

            // Removal of the center part
            translate([(main_frame[0] - top_cut_out[0]) / 2, (main_frame[1] - top_cut_out[1]) / 2, 0])
            cube(top_cut_out);  
        }
        translate([0,0,-top_layer[2]])  // We need the pegs to go down
        color(frame_color)
        connectors(peg_clearance);                   // Make the pegs
    }
}


module framed_text()
{
    if (show_text)
    {
        text_size = 10;                     // Font size
        defence_force_font = "Core Sans G:style=95 Black";
        
        // Rectangle frame around the text   
        rectangle(70,34,0.5,text_color);
        
        // "DEFENCE"
        translate([0,+8,0])
        linear_extrude(height=text_height)
        text("DEFENCE", size=text_size, font=defence_force_font, halign="center", valign="center");

        // "FORCE"
        translate([0,-8,0])
        linear_extrude(height=text_height)
        text("FORCE", size=text_size, font=defence_force_font, halign="center", valign="center");
    }
}


module rectangle(frame_width,frame_height,frame_thickness,color)
{
    color(color)
    linear_extrude(height=text_height)
    difference() 
    {
        // Outer rectangle
        square([frame_width, frame_height],center=true); 
        // Inner cutout
        square([frame_width - 2*frame_thickness, frame_height - 2*frame_thickness],center=true);         
    }
}


module notches()
{
    notch_size = [8.5, 2.7, 10];      // The three notches to close the box
    notch_edge_offset = 45.6;         // The top and bottom notches are not centered
    
    // Bottom notch
    translate([notch_edge_offset,0,0])
    cube(notch_size);

    // Top notch
    translate([notch_edge_offset,main_frame[1]-notch_size[1],0])
    cube(notch_size);

    // Side notch
    translate([main_frame[0],(main_frame[1]-notch_size[0])/2,0])
    rotate(90)
    cube(notch_size);
}


module connectors(clearance = 0) 
{
    hole_diameter = 4;    // Diameter of holes/pegs
    hole_depth = 7;       // Depth of holes (≤1mm for base plate)
    
    translate([4,4,0])
    cylinder(h=hole_depth, d=hole_diameter-clearance, $fn=32);

    translate([main_frame[0]-4,4,0])
    cylinder(h=hole_depth, d=hole_diameter-clearance, $fn=32);

    translate([4,main_frame[1]-4,0])
    cylinder(h=hole_depth, d=hole_diameter-clearance, $fn=32);

    translate([main_frame[0]-4,main_frame[1]-4,0])
    cylinder(h=hole_depth, d=hole_diameter-clearance, $fn=32);
}

