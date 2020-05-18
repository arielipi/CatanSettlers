import java.io.IOException;
import java.util.Map;
import java.util.Scanner;
import org.cs3.prolog.connector.Connector;
import org.cs3.prolog.connector.common.QueryUtils;
import org.cs3.prolog.connector.process.PrologProcess;
import org.cs3.prolog.connector.process.PrologProcessException;
import javax.swing.JButton;
import javax.swing.JOptionPane;

import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

public class GameManager {
	
	private static MainMap mainMap;

	public static String[] setupGame(PrologProcess process) {
		try {
			String[] array = {
					Messages.getString("GameManager.0"), 
					Messages.getString("GameManager.1") 
			};
			process.queryOnce(Messages.getString("GameManager.2")); 
			process.queryOnce(Messages.getString("GameManager.3")); 
			mainMap.addTown(4, 6, Messages.getString("GameManager.4")); 
			mainMap.addTown(4, 2, Messages.getString("GameManager.5")); 
			mainMap.addRoad(4, 6, 4, 5, Messages.getString("GameManager.6")); 
			mainMap.addRoad(4, 2, 3, 3, Messages.getString("GameManager.7")); 
			
			mainMap.addTown(7, 7, Messages.getString("GameManager.8")); 
			mainMap.addTown(8,5, Messages.getString("GameManager.9")); 
			mainMap.addRoad(7, 7, 8, 6, Messages.getString("GameManager.10")); 
			mainMap.addRoad(8, 6, 8, 5, Messages.getString("GameManager.11")); 
			
			return array;
		} catch (PrologProcessException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	
	public static boolean checkGivenResourcesForDesiredBuilding(PrologProcess process, Map<String, Object> result, String building, String resources) {
		String resourcesQuery = Messages.getString("GameManager.12") + building + Messages.getString("GameManager.13") + resources + Messages.getString("GameManager.14");   //$NON-NLS-3$
		String checkBuildingResourcesQuery = QueryUtils.bT(resourcesQuery);
		
		// check player has enough resources to building
		try {
			result = process.queryOnce(checkBuildingResourcesQuery);
		} catch (PrologProcessException e) {
			e.printStackTrace();
		}
		
		if (result == null) {
            // if the result is null, the query failed (no results)
            System.out.println(Messages.getString("GameManager.15")); 
            return false;
        } else {
            // if the query succeeds, the resulting map contains mappings
            // from variable name to the binding
            System.out.println(result.get(Messages.getString("GameManager.16"))); 
            if(!result.get(Messages.getString("GameManager.17")).equals(Messages.getString("GameManager.18")))  
            {
            	System.out.println(Messages.getString("GameManager.19")); 
            	return false;
            }
            System.out.println(Messages.getString("GameManager.20")); 
        }
		return true;
	}
	
	
	
	public static boolean checkTownExist(PrologProcess process, Map<String, Object> result, int line, int column) {
		String checkTownExist = Messages.getString("GameManager.21") + line + Messages.getString("GameManager.22") + column + Messages.getString("GameManager.23");   //$NON-NLS-3$
		String checkTownExistQuery = QueryUtils.bT(checkTownExist);
		// check spot availability
		try {
			result = process.queryOnce(checkTownExistQuery);
		} catch (PrologProcessException e) {
			e.printStackTrace();
		}
		if (result == null) {
            // if the result is null, the query failed (no results)
            System.out.println(Messages.getString("GameManager.24")); 
            return false;
        } else {
            // if the query succeeds, the resulting map contains mappings
            // from variable name to the binding
            System.out.println(result.get(Messages.getString("GameManager.25"))); 
            if(!result.get(Messages.getString("GameManager.26")).equals(Messages.getString("GameManager.27")))  
            {
            	System.out.println(Messages.getString("GameManager.28")); 
            	return false;
            }
            System.out.println(Messages.getString("GameManager.29")); 
        }
		return true;
	}
	
	
	public static String getPlayerResources(PrologProcess process, Map<String, Object> result, String resources, String color) {
		String playerResources = Messages.getString("GameManager.30") + resources + Messages.getString("GameManager.31") + color + Messages.getString("GameManager.32");   //$NON-NLS-3$
		String playerResourcesQuery = QueryUtils.bT(playerResources);
		
		try {
			result = process.queryOnce(playerResourcesQuery);
		} catch (PrologProcessException e) {
			e.printStackTrace();
		}
		if (result == null) {
            // if the result is null, the query failed (no results)
            System.out.println(Messages.getString("GameManager.33")); 
            return Messages.getString("GameManager.34"); 
        } else {
            // if the query succeeds, the resulting map contains mappings
            // from variable name to the binding
            
            String x = QueryUtils.objectsToArgList(result.get(Messages.getString("GameManager.35"))); 
            x = x.substring(1, x.length()-1);
            return x;
        }
	}
	
	public static boolean buildTown(PrologProcess process, int line, int column, String resources, String color) {
		
		Map<String, Object> result = null;
		
		resources = getPlayerResources(process, result, resources, color);
		System.out.println(resources);
		
		// check for enough resources
		if(!checkGivenResourcesForDesiredBuilding(process, result, Messages.getString("GameManager.36"), resources)) 
			return false;	
		
		// means that spot desired is taken
		if(!checkTownExist(process, result, line, column))
			return false; 
		
		String getRoadsConnectedToPoint = Messages.getString("GameManager.37") + line + Messages.getString("GameManager.38") + column + Messages.getString("GameManager.39");   //$NON-NLS-3$
		String getRoadsConnectedToPointQuery = QueryUtils.bT(getRoadsConnectedToPoint);
		// check spot availability
		try {
			result = process.queryOnce(getRoadsConnectedToPointQuery);
		} catch (PrologProcessException e) {
			e.printStackTrace();
		}
		if (result == null) {
            // if the result is null, the query failed (no results)
            System.out.println(Messages.getString("GameManager.40")); 
            return false;
        } else {
            // no roads connected
            if(result.get(Messages.getString("GameManager.43")).equals(Messages.getString("GameManager.44"))) {
            	System.out.println("could not build town");
            	return false;
            }
            
            String roads = QueryUtils.objectsToArgList(result.get(Messages.getString("GameManager.45"))); 
            roads = roads.substring(2,  roads.length() - 2);
            if(roads.equals(Messages.getString("GameManager.46"))) 
            	return false;
            roads = roads.replaceAll(Messages.getString("GameManager.47"), Messages.getString("GameManager.48"));  

            String[] roadsArray = roads.split(Messages.getString("GameManager.49")); 
            for(int i = 0; i < roadsArray.length; i++) {
            	if(i == roadsArray.length - 1) {
            		roadsArray[i] = roadsArray[i].replaceFirst(Messages.getString("GameManager.50"), Messages.getString("GameManager.51"));  
            	}
            	System.out.println(roadsArray[i]);
            }
            
            
            // check for neighboring cities/towns
            for (String string : roadsArray) {
            	int line2 = Integer.parseInt(string.split(Messages.getString("GameManager.52"))[0]); 
            	int column2 = Integer.parseInt(string.split(Messages.getString("GameManager.53"))[1]); 
            	
            	System.out.println(Messages.getString("GameManager.54") + line2 + Messages.getString("GameManager.55") + column2);  
            	// means spot is taken by a town
            	if(!checkTownExist(process, result, line2, column2))
            		return false;
			}
            
            
            
            String buildTown = Messages.getString("GameManager.56") + line + Messages.getString("GameManager.57") + column + Messages.getString("GameManager.58") + color + Messages.getString("GameManager.59");   //$NON-NLS-3$ //$NON-NLS-4$
            String buildTownQuery = QueryUtils.bT(buildTown);
            mainMap.addTown(column, line, color);
			mainMap.paint(mainMap.getGraphics());
            
            try {
    			result = process.queryOnce(buildTownQuery);
    		} catch (PrologProcessException e) {
    			e.printStackTrace();
    		}
        }
		return true;
	}
	
	private static void myAssert(PrologProcess process, Scanner scanner) {
		System.out.println(Messages.getString("GameManager.67")); 
		String answer = scanner.nextLine();
		System.out.println(Messages.getString("GameManager.68")); 
		String returnValue = scanner.nextLine();
		Map<String, Object> result = null;
		
		
		String answerQuery = QueryUtils.bT(answer);
		// check spot availability
		try {
			result = process.queryOnce(answerQuery);
		} catch (PrologProcessException e) {
			e.printStackTrace();
		}
		if (result == null) {
            // if the result is null, the query failed (no results)
            System.out.println(Messages.getString("GameManager.69")); 
            return;
        } else {
            // if the query succeeds, the resulting map contains mappings
            // from variable name to the binding
            System.out.println(result.get(returnValue));
        }

		return;
	}
	
	
	public static void manageGame(PrologProcess process, String redResources, String aiResources, Scanner s) {
		
		int line, line2, column, column2, diceRoll;
		boolean updateResourcesFlag;
		boolean AITurn = true;
		String answer = Messages.getString("GameManager.70"); 
		
		while(!answer.equals(Messages.getString("GameManager.71"))) { 
			AITurn = !AITurn;
			if(isWin(process, AITurn)) {
				mainMap.announceWinner(AITurn);
				break;
			}
			
			if(AITurn) {
				mainMap.addLine(Messages.getString("GameManager.990")); 
			} else {
				mainMap.addLine(Messages.getString("GameManager.991"));
			}
			
			diceRoll = rollDice(process);
			mainMap.addLine(Messages.getString("GameManager.74") + diceRoll); 
			aiResources = updateResourcesStartOfTurn(process, aiResources, Messages.getString("GameManager.75"), diceRoll); 
			redResources = updateResourcesStartOfTurn(process, redResources, Messages.getString("GameManager.76"), diceRoll); 
			
			if(AITurn) {
				answer = Messages.getString("GameManager.77"); 
				updateResourcesFlag = false;
				while(!answer.equals(Messages.getString("GameManager.78"))) { 
					answer = aiTurn(process, aiResources, Messages.getString("GameManager.79")); 
					System.out.println("this is answer " + answer);
					if(answer.equals(Messages.getString("GameManager.80"))) {
						System.out.println(Messages.getString("GameManager.81"));
					} else if (answer.equals(Messages.getString("GameManager.82"))) { 
						aiResources = updatePlayerResources(process, Messages.getString("GameManager.83"), aiResources);
					} else if (answer.equals(Messages.getString("GameManager.84"))) { 
						aiResources = updatePlayerResources(process, Messages.getString("GameManager.85"), aiResources);
					} else if (answer.equals(Messages.getString("GameManager.86"))) { 
						aiResources = updatePlayerResources(process, Messages.getString("GameManager.87"), aiResources);
					} else {
						System.out.println(Messages.getString("GameManager.88") + answer); 
					}
				}
			} 
			else { // human turn
				System.out.println(Messages.getString("GameManager.89"));
				answer = s.nextLine();
				while(!answer.equals(Messages.getString("GameManager.90"))) {
					switch(answer.toLowerCase()) {
					case "build a town":
					case "1":
						System.out.println(Messages.getString("GameManager.93") + answer);
						System.out.print(Messages.getString("GameManager.94"));
						line = s.nextInt();
						System.out.print(Messages.getString("GameManager.95"));
						column = s.nextInt();
						updateResourcesFlag = buildTown(process, line, column, redResources, Messages.getString("GameManager.96"));
						if(updateResourcesFlag) {
							redResources = updatePlayerResources(process, Messages.getString("GameManager.97"), redResources);
							System.out.println(redResources);
						}
						break;
					case "build a road": 
					case "2": 
						System.out.println(Messages.getString("GameManager.100") + answer); 
						System.out.print(Messages.getString("GameManager.101")); 
						line = s.nextInt();
						System.out.print(Messages.getString("GameManager.102")); 
						column = s.nextInt();
						System.out.print(Messages.getString("GameManager.103")); 
						line2 = s.nextInt();
						System.out.print(Messages.getString("GameManager.104")); 
						column2 = s.nextInt();
						updateResourcesFlag = buildRoad(process, line, column, line2, column2, redResources, Messages.getString("GameManager.105")); 
						if(updateResourcesFlag) {
							redResources = updatePlayerResources(process, Messages.getString("GameManager.106"), redResources); 
							System.out.println(redResources);
						}
						break;
					case "build a city": 
					case "3": 
						System.out.println(Messages.getString("GameManager.109") + answer); 
						System.out.print(Messages.getString("GameManager.110")); 
						line = s.nextInt();
						System.out.print(Messages.getString("GameManager.111")); 
						column = s.nextInt();
						updateResourcesFlag = buildCity(process, line, column, redResources, Messages.getString("GameManager.112")); 
						System.out.println(updateResourcesFlag);
						if(updateResourcesFlag) {
							redResources = updatePlayerResources(process, Messages.getString("GameManager.113"), redResources); 
							System.out.println(redResources);
						}
						break;
					case "assert": 
					case "00": 
						myAssert(process, s);
						break;
					}
					
					// next move
					System.out.print(Messages.getString("GameManager.116")); 
					s.nextLine();
					answer = s.nextLine();
				}
				// end turn
			}
		}
	}


	private static String updateResourcesStartOfTurn(PrologProcess process, String resources, String color, int oddity) {
		Map<String, Object> result = null;
		String updateResourcesDice = Messages.getString("GameManager.117") + oddity + Messages.getString("GameManager.118") + color + Messages.getString("GameManager.119") + resources + Messages.getString("GameManager.120");   //$NON-NLS-3$ //$NON-NLS-4$
		String updateResourcesDiceQuery = QueryUtils.bT(updateResourcesDice);
		try {
			result = process.queryOnce(updateResourcesDiceQuery);
		} catch (PrologProcessException e) {
			e.printStackTrace();
		}
		if (result == null) {
            // if the result is null, the query failed (no results)
            System.out.println(Messages.getString("GameManager.121")); 
            return resources;
        } else {
            // if the query succeeds, the resulting map contains mappings
            // from variable name to the binding
            System.out.println(color + Messages.getString("GameManager.122") + result.get(Messages.getString("GameManager.123")));  
            return Messages.getString("GameManager.124") + result.get(Messages.getString("GameManager.125"));  
        }
	}



	private static int rollDice(PrologProcess process) {
		Map<String, Object> result = null;
		
		String rollDiceResult = Messages.getString("GameManager.126"); 
		String rollDiceResultQuery = QueryUtils.bT(rollDiceResult);
		try {
			result = process.queryOnce(rollDiceResultQuery);
		} catch (PrologProcessException e) {
			e.printStackTrace();
		}
		if (result == null) {
            // if the result is null, the query failed (no results)
            System.out.println(Messages.getString("GameManager.127")); 
            return 0;
        } else {
            // if the query succeeds, the resulting map contains mappings
            // from variable name to the binding
            System.out.println(Messages.getString("GameManager.128") + result.get(Messages.getString("GameManager.129")));  
            int tryParse = Integer.parseInt(Messages.getString("GameManager.130") + result.get(Messages.getString("GameManager.131")));  
            return tryParse;
        }
	}



	private static boolean isWin(PrologProcess process, boolean AITurn) {
		Map<String, Object> result = null;
		String color = Messages.getString("GameManager.132"); 
		if(AITurn)
			color = Messages.getString("GameManager.133"); 
		else
			color = Messages.getString("GameManager.134"); 
		String findPoints = Messages.getString("GameManager.135") + color + Messages.getString("GameManager.136");  
		String findPointsQuery = QueryUtils.bT(findPoints);

		try {
			result = process.queryOnce(findPointsQuery);
		} catch (PrologProcessException e) {
			e.printStackTrace();
		}
		if (result == null) {
            // if the result is null, the query failed (no results)
            System.out.println(Messages.getString("GameManager.137")); 
            return false;
        } else {
        	int points = Integer.parseInt("" + result.get(Messages.getString("GameManager.138")));
            if(points >= 10)
            	return true;
            return false;
        }
	}



	private static String aiTurn(PrologProcess process, String resources, String color) {
		// The AI finds out what to build and builds it. it only returns info to what was built and where.
		// In case of road it gives one of the ends of it, request the whole road by asking for lastroadbuilt 
		Map<String, Object> result = null;

		resources = getPlayerResources(process, result, resources, color);
		
		String aiTurn = Messages.getString("GameManager.140") + resources + Messages.getString("GameManager.141") + color + Messages.getString("GameManager.142");   //$NON-NLS-3$
		String aiTurnQuery = QueryUtils.bT(aiTurn);
		// check spot availability
		try {
			result = process.queryOnce(aiTurnQuery);
		} catch (PrologProcessException e) {
			e.printStackTrace();
		}
		if (result == null) {
            // if the result is null, the query failed (no results)
            System.out.println(Messages.getString("GameManager.143")); 
            return Messages.getString("GameManager.144"); 
        } else {
            // if the query succeeds, the resulting map contains mappings
            // from variable name to the binding
            //System.out.println(result.get("ReturnValue"));

            if(result.get(Messages.getString("GameManager.145")).equals(Messages.getString("GameManager.146")))  
            	return Messages.getString("GameManager.147"); 
            
            // else something was built, draw accordingly

            System.out.println("this is ReturnValue" + result.get(Messages.getString("GameManager.145")));
            System.out.println("this is ValueToRet" +  result.get(Messages.getString("GameManager.148")));
            if(result.get(Messages.getString("GameManager.148")).equals(Messages.getString("GameManager.149"))) {  
            	String road = getLastRoad(process);
            	if(road.equals(Messages.getString("GameManager.150"))) 
            		return Messages.getString("GameManager.151"); 
            	road = road.replaceAll(Messages.getString("GameManager.152"), Messages.getString("GameManager.153"));  
            	road = road.replaceAll(Messages.getString("GameManager.154"), Messages.getString("GameManager.155"));  
            	road = road.replaceAll(Messages.getString("GameManager.156"), Messages.getString("GameManager.157"));  
            	
            	String[] roadCoords = road.split(Messages.getString("GameManager.158")); 
            	String[] roadCoords0 = roadCoords[0].split(Messages.getString("GameManager.159")); 
            	String roadCoords1 = roadCoords0[0].replaceAll(Messages.getString("GameManager.160"), Messages.getString("GameManager.161"));  
            	String roadCoords2 = roadCoords0[1].replaceAll(Messages.getString("GameManager.162"), Messages.getString("GameManager.163"));  
            	String[] roadCoords11 = roadCoords1.split(Messages.getString("GameManager.164")); 
            	String[] roadCoords22 = roadCoords2.split(Messages.getString("GameManager.165")); 
            	
            	mainMap.addLine(Messages.getString("GameManager.166") + roadCoords[0]); 
            	
            	int line = Integer.parseInt(roadCoords11[0]);
            	int column = Integer.parseInt(roadCoords11[1]);
            	int line2 = Integer.parseInt(roadCoords22[0]);
            	int column2 = Integer.parseInt(roadCoords22[1]);
            	
            	mainMap.addRoad(column, line, column2, line2, color);
    			mainMap.paint(mainMap.getGraphics());
            	;
            } else if(result.get(Messages.getString("GameManager.167")).equals(Messages.getString("GameManager.168"))) {  
            	String town = Messages.getString("GameManager.169") + result.get(Messages.getString("GameManager.170"));  
            	town = town.substring(7, town.length() -1);
            	mainMap.addLine(Messages.getString("GameManager.171") + town); 
            	String[] townCoords = town.split(Messages.getString("GameManager.172")); 
            	
            	int line = Integer.parseInt(townCoords[0]);
            	int column = Integer.parseInt(townCoords[1]);
            	mainMap.addTown(column, line, color);
    			mainMap.paint(mainMap.getGraphics());
            	
            } else if(result.get(Messages.getString("GameManager.173")).equals(Messages.getString("GameManager.174"))) {  
            	String city = Messages.getString("GameManager.175") + result.get(Messages.getString("GameManager.176"));  
            	city = city.substring(7, city.length() -1);
            	mainMap.addLine(Messages.getString("GameManager.177") + city); 
            	String[] cityCoords = city.split(Messages.getString("GameManager.178")); 
            	
            	int line = Integer.parseInt(cityCoords[0]);
            	int column = Integer.parseInt(cityCoords[1]);
            	mainMap.addCity(column, line, color);
    			mainMap.paint(mainMap.getGraphics());
            	
            } 
        }
		return Messages.getString("GameManager.179") + result.get(Messages.getString("GameManager.180"));  
	}



	private static boolean buildCity(PrologProcess process, int line, int column, String resources, String color) {
		Map<String, Object> result = null;
		
		resources = getPlayerResources(process, result, resources, color);
		
		
		// check for enough resources
		if(!checkGivenResourcesForDesiredBuilding(process, result, Messages.getString("GameManager.181"), resources)) 
			return false;
		
		String checkTownExist = Messages.getString("GameManager.182") + line + Messages.getString("GameManager.183") + column + Messages.getString("GameManager.184") + color + Messages.getString("GameManager.185");   //$NON-NLS-3$ //$NON-NLS-4$
		String checkTownExistQuery = QueryUtils.bT(checkTownExist);
		// check spot availability
		try {
			result = process.queryOnce(checkTownExistQuery);
		} catch (PrologProcessException e) {
			e.printStackTrace();
		}
		if (result == null) {
            // if the result is null, the query failed (no results)
            System.out.println(Messages.getString("GameManager.186")); 
            return false;
        } else {
            // if the query succeeds, the resulting map contains mappings
            // from variable name to the binding
            //System.out.println(result.get("ReturnValue"));

            if(result.get(Messages.getString("GameManager.187")).equals(Messages.getString("GameManager.188")))  
            	return false;

            String buildCity = Messages.getString("GameManager.189") + line + Messages.getString("GameManager.190") + column + Messages.getString("GameManager.191") + color + Messages.getString("GameManager.192");   //$NON-NLS-3$ //$NON-NLS-4$
            String buildCityQuery = QueryUtils.bT(buildCity);
            mainMap.addCity(column, line, color);
            mainMap.paint(mainMap.getGraphics());
            try {
    			result = process.queryOnce(buildCityQuery);
    			//mainMap.addCity(line, column, color);
    			mainMap.paint(mainMap.getGraphics());
    		} catch (PrologProcessException e) {
    			e.printStackTrace();
    		}
        }
		return true;
	}

	
	
	private static String getLastRoad(PrologProcess process) {
		Map<String, Object> result = null;		
		
		
		String getLastRoad = Messages.getString("GameManager.193"); 
		String getLastRoadQuery = QueryUtils.bT(getLastRoad);
		try {
			result = process.queryOnce(getLastRoadQuery);
		} catch (PrologProcessException e) {
			e.printStackTrace();
		}
		if (result == null) {
            // if the result is null, the query failed (no results)
            System.out.println(Messages.getString("GameManager.194")); 
            return Messages.getString("GameManager.195"); 
        } else {
            if(result.get(Messages.getString("GameManager.196")).equals(Messages.getString("GameManager.197")))  
            	return Messages.getString("GameManager.198"); 
        }
		return Messages.getString("GameManager.199") + result.get(Messages.getString("GameManager.200"));  
	}


	private static boolean buildRoad(PrologProcess process, int line, int column, int line2, int column2, String resources, String color) {
		Map<String, Object> result = null;		
		resources = getPlayerResources(process, result, resources, color);

		if(!checkGivenResourcesForDesiredBuilding(process, result, Messages.getString("GameManager.201"), resources)) 
			return false;	
		
		String checkConnectivityRoad = Messages.getString("GameManager.202") + line + Messages.getString("GameManager.203") + column + Messages.getString("GameManager.204") + line2 + Messages.getString("GameManager.205") + column2 + Messages.getString("GameManager.206") + color + Messages.getString("GameManager.207");   //$NON-NLS-3$ //$NON-NLS-4$ //$NON-NLS-5$ //$NON-NLS-6$
		String checkConnectivityRoadQuery = QueryUtils.bT(checkConnectivityRoad);
		try {
			result = process.queryOnce(checkConnectivityRoadQuery);
		} catch (PrologProcessException e) {
			e.printStackTrace();
		}
		if (result == null) {
            // if the result is null, the query failed (no results)
            System.out.println(Messages.getString("GameManager.208")); 
            return false;
        } else {
            if(result.get(Messages.getString("GameManager.209")).equals(Messages.getString("GameManager.210"))) {
            	System.out.println("road is not connected");
            	return false;
            }
            String buildRoad = Messages.getString("GameManager.211") + line + Messages.getString("GameManager.212") + column + Messages.getString("GameManager.213") + line2 + Messages.getString("GameManager.214") + column2 + Messages.getString("GameManager.215") + color + Messages.getString("GameManager.216");   //$NON-NLS-3$ //$NON-NLS-4$ //$NON-NLS-5$ //$NON-NLS-6$
            String buildRoadQuery = QueryUtils.bT(buildRoad);
            try {
    			result = process.queryOnce(buildRoadQuery);
    			mainMap.addRoad(column, line, column2, line2, color);
    			mainMap.paint(mainMap.getGraphics());
    		} catch (PrologProcessException e) {
    			e.printStackTrace();
    		}
        }
		return true;
	}



	private static String updatePlayerResources(PrologProcess process, String building, String resources) {
		String resourceUpdate= Messages.getString("GameManager.217"); 
		String resourceUpdateQuery = Messages.getString("GameManager.218"); 
		String returnValue = Messages.getString("GameManager.219"); 
		Map<String, Object> result = null;
		if(building.equals(Messages.getString("GameManager.220"))) { 
			resourceUpdate = Messages.getString("GameManager.221") + resources + Messages.getString("GameManager.222");  
			resourceUpdateQuery = QueryUtils.bT(resourceUpdate);
			returnValue = Messages.getString("GameManager.223"); 
			
			
			try {
				result = process.queryOnce(resourceUpdateQuery);
			} catch (PrologProcessException e) {
				e.printStackTrace();
			}
			if (result == null) {
	            // if the result is null, the query failed (no results)
	            System.out.println(Messages.getString("GameManager.224")); 
	            return Messages.getString("GameManager.225"); 
	        } else {
	            // if the query succeeds, the resulting map contains mappings
	            // from variable name to the binding
	            //System.out.println(result.get(returnValue));
	            Object v = result.get(returnValue);
	    		String toReturn = v.toString();

	    		return toReturn;
	        }
		} else if(building.equals(Messages.getString("GameManager.226"))) { 
			resourceUpdate = Messages.getString("GameManager.227") + resources + Messages.getString("GameManager.228");  
			resourceUpdateQuery = QueryUtils.bT(resourceUpdate);
			returnValue = Messages.getString("GameManager.229"); 
			
			try {
				result = process.queryOnce(resourceUpdateQuery);
			} catch (PrologProcessException e) {
				e.printStackTrace();
			}
			if (result == null) {
	            // if the result is null, the query failed (no results)
	            System.out.println(Messages.getString("GameManager.230")); 
	            return Messages.getString("GameManager.231"); 
	        } else {
	            // if the query succeeds, the resulting map contains mappings
	            // from variable name to the binding
	            //System.out.println(result.get(returnValue));
	            Object v = result.get(returnValue);
	    		String toReturn = v.toString();

	    		return toReturn;
	        }
		} else if(building.equals(Messages.getString("GameManager.232"))) { 
			resourceUpdate = Messages.getString("GameManager.233") + resources + Messages.getString("GameManager.234");  
			resourceUpdateQuery = QueryUtils.bT(resourceUpdate);
			returnValue = Messages.getString("GameManager.235"); 
			
			try {
				result = process.queryOnce(resourceUpdateQuery);
			} catch (PrologProcessException e) {
				e.printStackTrace();
			}
			if (result == null) {
	            // if the result is null, the query failed (no results)
	            //System.out.println("not found");
	            return Messages.getString("GameManager.236"); 
	        } else {
	            // if the query succeeds, the resulting map contains mappings
	            // from variable name to the binding
	            //System.out.println(result.get(returnValue));
	            Object v = result.get(returnValue);
	    		String toReturn = v.toString();

	    		return toReturn;
	        }
		}
		
		return null;
	}



	public static void main(String[] args) throws IOException {
		mainMap = new MainMap();
		
		
		//mainMap.getContentPane().add(btnHowToPlay);
		try {
			String CSwiPL = Messages.getString("GameManager.2371");
			String CSwiPLx86 = Messages.getString("GameManager.2372");
			String DSwiPL = Messages.getString("GameManager.2381");
			String DSwiPLx86 = Messages.getString("GameManager.2382");
			//System.out.println(DSwiPLx86);
			String Home_Map = Messages.getString("GameManager.239"); 
			String LapTop = Messages.getString("GameManager.240"); 
			
			PrologProcess process;
			String consultQuery;
			
			Scanner s = new Scanner(System.in);
			System.out.println(Messages.getString("GameManager.999"));
			String x86 = s.nextLine();
			boolean x86Flag = Boolean.parseBoolean(x86);
			System.out.println(x86Flag);
			System.out.println(Messages.getString("GameManager.241")); 
			String CDriveFlagString = s.nextLine();
			boolean CDriveFlag = Boolean.parseBoolean(CDriveFlagString);
			
			if(CDriveFlag) {
				if(x86Flag) {
					process = Connector.newPrologProcess(CSwiPLx86);
				} else {
					process = Connector.newPrologProcess(CSwiPL);
				}
				
				consultQuery = QueryUtils.bT(Messages.getString("GameManager.242"), LapTop); 
				process.queryOnce(consultQuery);
			}
			else {
				if(x86Flag) {
					System.out.println("entered x86Flag inside not laptop");
					process = Connector.newPrologProcess(DSwiPLx86);
				} else {
					System.out.println("entered not x86Flag inside not laptop");
					process = Connector.newPrologProcess(DSwiPL);
				}
				
				consultQuery = QueryUtils.bT(Messages.getString("GameManager.243"), Home_Map); 
				process.queryOnce(consultQuery);
			}
			
			
			String[] players = setupGame(process);
			String redPlayer = players[0];
			String bluePlayer = players[1];
			
			String redResources = getResorcesOfPlayer(process, redPlayer);
			System.out.println(redResources);
			String aiResources = getResorcesOfPlayer(process, bluePlayer);
			System.out.println(aiResources);

			manageGame(process, redResources, aiResources, s);
			
			s.close();
			
			
			
            
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (PrologProcessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		

	}
	
	
	private static String getResorcesOfPlayer(PrologProcess process, String player) {
		String playerResources = Messages.getString("GameManager.244") + player + Messages.getString("GameManager.245");  
		String playerResourcesQuery = QueryUtils.bT(playerResources);
		
		Map<String, Object> result = null;
		try {
			result = process.queryOnce(playerResourcesQuery);
		} catch (PrologProcessException e) {
			e.printStackTrace();
		}
		if (result == null) {
            // if the result is null, the query failed (no results)
            System.out.println(Messages.getString("GameManager.246")); 
            return Messages.getString("GameManager.247"); 
        } else {
            // if the query succeeds, the resulting map contains mappings
            // from variable name to the binding
            
            String x = QueryUtils.objectsToArgList(result.get(Messages.getString("GameManager.248"))); 
            x = x.substring(1, x.length()-1);
            return x;
        }
	}
}
