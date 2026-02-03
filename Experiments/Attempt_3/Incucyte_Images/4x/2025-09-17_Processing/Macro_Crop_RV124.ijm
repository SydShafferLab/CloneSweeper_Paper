//Open grayscale to convert to 16-bit:
File.openSequence("/Users/robertvandervelde/Library/CloudStorage/GoogleDrive-robertvandervelde@sydshafferlab.com/My Drive/Vander_Velde_Share/Experiments/RV124/Attempt_3/Incucyte_Images/4x/Raw_Uncalibrated/", "filter=Grayscale");

run("16-bit");

//Get green images:
File.openSequence("/Users/robertvandervelde/Library/CloudStorage/GoogleDrive-robertvandervelde@sydshafferlab.com/My Drive/Vander_Velde_Share/Experiments/RV124/Attempt_3/Incucyte_Images/4x/Raw_Uncalibrated/", "filter=Green");

//Get red images:
File.openSequence("/Users/robertvandervelde/Library/CloudStorage/GoogleDrive-robertvandervelde@sydshafferlab.com/My Drive/Vander_Velde_Share/Experiments/RV124/Attempt_3/Incucyte_Images/4x/Raw_Uncalibrated/", "filter=Red");

run("Concatenate...", "all_open");

makeRectangle(8068,3524,114,114);
run("Crop");

run("Stack to Hyperstack...", "order=xytcz channels=3 slices=1 frames=4 display=Composite");

Stack.setChannel(1);
run("Grays");
setMinAndMax(90,160);

//Make scale bar in grayscale channel:
makeRectangle(5,106,20,3);
setForegroundColor(65535, 65535, 65535);
run("Fill");
run("Select None");

Stack.setChannel(2);
run("Blue");
setMinAndMax(50,90);
Stack.setChannel(3);
run("Red");
setMinAndMax(13,20);

//Get dimensions to loop across "frames" (ie wells here):
Stack.getDimensions(width, height, channels, slices, frames);

//Rename hyperstack so loop can return to it:
rename("MyHyperstack")

//Save hyperstack:
saveAs("Tiff", "/Users/robertvandervelde/Library/CloudStorage/GoogleDrive-robertvandervelde@sydshafferlab.com/My Drive/Vander_Velde_Share/Experiments/RV124/Attempt_3/Incucyte_Images/4x/2025-09-17_Processing/" + getTitle() + ".tif");

//Loop across frames to flatten images:
for (t = 1; t < frames + 1; t++){
	//Return to hyperstack:
	selectWindow("MyHyperstack.tif");
	
	//Select next frame:
	Stack.setFrame(t);
	run("Flatten");
	
	//Rename flattened image:
	rename("Well_" + IJ.pad(t,3));
	
	saveAs("Tiff", "/Users/robertvandervelde/Library/CloudStorage/GoogleDrive-robertvandervelde@sydshafferlab.com/My Drive/Vander_Velde_Share/Experiments/RV124/Attempt_3/Incucyte_Images/4x/2025-09-17_Processing/" + getTitle() + ".tif");
}




