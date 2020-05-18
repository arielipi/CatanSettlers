import java.awt.Color;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URLDecoder;
import java.util.LinkedList;
import java.util.List;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Line2D;
import java.awt.GridLayout;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import javax.swing.JTextArea;
import java.awt.Font;

public class MainMap extends JFrame{
	
	List<Line2D.Double> blueLines;
	List<Line2D.Double> redLines;
	
	List<Ellipse2D.Double> blueTowns;
	List<Ellipse2D.Double> redTowns;
	JTextArea textArea;
	/**
	 * Create the frame.
	 * @throws IOException 
	 */
	public MainMap() throws IOException {
		
		blueLines = new LinkedList<Line2D.Double>();
		redLines = new LinkedList<Line2D.Double>();
		blueTowns = new LinkedList<Ellipse2D.Double>();
		redTowns = new LinkedList<Ellipse2D.Double>();
		
		getContentPane().setSize(1000, 800);
		setTitle(Messages.getString("MainMap.0"));
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
        File file;
        BufferedImage image = null; 
        
        JPanel contentPane = (JPanel) this.getContentPane();
        contentPane.setOpaque(true);
        getContentPane().setBackground(Color.WHITE);
        getContentPane().setLayout(null);
		String path;		
		
		try {
			path = Messages.getString("MainMap.ImagePath");
			file = new File(path);
	        image = ImageIO.read(file);
		}
		catch (Exception e) {
		}
        
        JLabel mapLabel = new JLabel(new ImageIcon(image));

        mapLabel.setBounds(0, 0, 800, 712);
        getContentPane().add(mapLabel);
        JButton btnHowToPlay = new JButton("How to Play");
		btnHowToPlay.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent arg0) {
				howToPlay();
			}

			private void howToPlay() {
				JOptionPane.showMessageDialog(null, "This game board is divided into lines and columns, starting from 0 and line ends in 11, columns ends in 10", "InfoBox: ", JOptionPane.INFORMATION_MESSAGE);
				JOptionPane.showMessageDialog(null, "Your goal is to reach 10 points. this is done by building towns (1 point each) and cities (2 points each)", "InfoBox: ", JOptionPane.INFORMATION_MESSAGE);
				JOptionPane.showMessageDialog(null, "in order to build towns you need to build roads and have at least space of at least two edges from any town/city", "InfoBox: ", JOptionPane.INFORMATION_MESSAGE);
				JOptionPane.showMessageDialog(null, "cities are build on towns, and roads have to be continuous", "InfoBox: ", JOptionPane.INFORMATION_MESSAGE);
				JOptionPane.showMessageDialog(null, "at each start of turn two dices are rolled, any town/city that you have on a cell that holds the number that is the sum of the dices gives you 1 (town) or 2 (city) of that resource", "InfoBox: ", JOptionPane.INFORMATION_MESSAGE);
				JOptionPane.showMessageDialog(null, "input you can give - 1 to build a town, 2 for a road, 3 for a city. 00 to cheat - this option you must give a prolog input to be proccessed. warning, this can lead to hazardous results.", "InfoBox: ", JOptionPane.INFORMATION_MESSAGE);
				JOptionPane.showMessageDialog(null, "Good Luck", "InfoBox: ", JOptionPane.INFORMATION_MESSAGE);
			}
		});
		btnHowToPlay.setBounds(807, 411, 149, 23);
		getContentPane().add(btnHowToPlay);
        
        textArea = new JTextArea(Messages.getString("MainMap.3"), 80, 80);
        textArea.setBounds(808, 11, 230, 390);
        textArea.setFont(new Font(Messages.getString("MainMap.4"), Font.PLAIN, 11));
        textArea.setBackground(Color.LIGHT_GRAY);
        
		JPanel centerPanel = new JPanel(new GridLayout(1,1));
		centerPanel.add(new JScrollPane(textArea));
		centerPanel.setBounds(808, 11, 230, 390);
		getContentPane().add(centerPanel);
        setSize(1076, 800);
        setLocationByPlatform(true);
        setVisible(true);
        
	}
	
	// add line to the textarea
	public void addLine(String lineToAdd) {
		textArea.setText(textArea.getText() + Messages.getString("MainMap.5") + lineToAdd); //$NON-NLS-1$
	}
	
	
	// translate given line to frame's location
	private int findLine(int line) {
		int lineFixed = 125;
		for(int i = 0; i < line/2; i++) {
			lineFixed += 30;
		}
		for(int i = 0; i < line/2; i++) {
			lineFixed += 65;
		}
		if(line%2 == 1) {
			lineFixed += 30;
		}
		
		if(line == 7) {
			lineFixed += 5;
		}
		else if(line >= 8) {
			lineFixed += 15;
		}
		
		return lineFixed;
	}
	
	// translate given column to frame's location
	private int findColumn(int column) {
		int columnFixed = 115;
		for(int i = 0; i < column; i++) {
			columnFixed += 60;
		}
		if(column == 7) {
			columnFixed -= 10; 
		}
		else if(column >= 8) {
			columnFixed -= 12;
		}
		
		return columnFixed;
	}
	// add road on map
	public void addRoad(int x1, int y1, int x2, int y2, String color) {
		int x1Translated = findColumn(x1);
		int x2Translated = findColumn(x2);
		int y1Translated = findLine(y1);
		int y2Translated = findLine(y2);
		Line2D.Double line = new Line2D.Double(x1Translated, y1Translated, x2Translated, y2Translated);
		
		if(color.equals(Messages.getString("MainMap.6"))) { //$NON-NLS-1$
			redLines.add(line);
		} else {
			blueLines.add(line);
			paintRoads(this.getGraphics());
		}
	}
	
	// add town on map
	public void addTown(int x1, int y1, String color) {
		int x1Translated = findColumn(x1);
		int y1Translated = findLine(y1);
		
		Ellipse2D.Double circle = new Ellipse2D.Double(x1Translated-25, y1Translated-30, 50, 50);
		
		if(color.equals(Messages.getString("MainMap.7"))) {
			redTowns.add(circle);
		} else {
			blueTowns.add(circle);
		}
	}
	
	// add city on map
	public void addCity(int x1, int y1, String color) {
		int x1Translated = findColumn(x1);
		int y1Translated = findLine(y1);

		Ellipse2D.Double circle = new Ellipse2D.Double(x1Translated-35, y1Translated-40, 70, 70);

		
		if(color.equals(Messages.getString("MainMap.8"))) {
			redTowns.add(circle);
		} else {
			blueTowns.add(circle);
		}
	}
	
	// paint all the roads!
	public void paintRoads(Graphics g) {
		g.setColor(Color.BLUE);
		
		for(Line2D.Double line : blueLines) {
			g.drawLine((int)line.x1, (int)line.y1, (int)line.x2, (int)line.y2);
			
		}
		
		g.setColor(Color.RED);
		
		for(Line2D.Double line : redLines) {
			g.drawLine((int)line.x1, (int)line.y1, (int)line.x2, (int)line.y2);
			
		}
	}
	// paint all the towns!
	public void paintTowns(Graphics g) {
		g.setColor(Color.BLUE);
		
		for(Ellipse2D.Double circle : blueTowns) {
			g.drawOval((int)circle.x, (int)circle.y, (int)circle.height, (int)circle.width);
			
		}
		
		g.setColor(Color.RED);
		
		for(Ellipse2D.Double circle : redTowns) {
			g.drawOval((int)circle.x, (int)circle.y, (int)circle.height, (int)circle.width);
			
		}
	}
	
	// paint all the things!
	public void paint(Graphics g) {
		super.paint(g);
		paintRoads(g);
		paintTowns(g);
	}

	
	// add line of winner
	public void announceWinner(boolean AITurn) {
		if(AITurn) {
			addLine(Messages.getString("MainMap.9"));
		} else {
			addLine(Messages.getString("MainMap.10"));
		}
		
		
	}
}
