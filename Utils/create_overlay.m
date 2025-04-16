function overlay = create_overlay(label_mat,prediction_mat, show)
%CREATE_OVERLAY Creates an overlay from instance maps files with label and
% prediction
% label_mat - instance map for ground truth
% prediction_mat - instance map for prediction
% show - show a figure or not

[n,m,~]=size(prediction_mat);
overlay=zeros(n,m,3,"uint8");

TP = uint8(label_mat & prediction_mat);
TP(TP==1) = 255;
FP = uint8(prediction_mat & ~label_mat);
FP(FP==1)=255;
FN = uint8(~prediction_mat & label_mat);
FN(FN==1) = 255;

overlay(:,:,2) = TP;
overlay(:,:,1) = FP;
overlay(:,:,3) = FN;
black_pixels = all(overlay == 0, 3);
overlay(repmat(black_pixels, [1 1 3])) = 255;

if(show)
    imshow(overlay);
end

end

