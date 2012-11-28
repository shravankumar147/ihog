function im = showpairdict(pd, w, h),

if ~exist('w', 'var'),
  sy = 10;
end
if ~exist('h', 'var'),
  sx = 10;
end

hny = pd.dim(1);
hnx = pd.dim(2);
sbin = pd.sbin;

gny = (hny+2)*sbin;
gnx = (hnx+2)*sbin;

bord = 10;
cy = (gny+bord);
cx = (gnx*2+bord);

im = zeros(cy, cx);

iii = randperm(size(pd.dgray,2));
for i=1:sy*sx,
  row = mod(i-1, sx)+1;
  col = floor((i-1) / sx)+1;

  graypic = reshape(pd.dgray(:, iii(i)), [gny gnx]);
  graypic(:) = graypic(:) - min(graypic(:));
  graypic(:) = graypic(:) / max(graypic(:));

  hogfeat = reshape(pd.dhog(:, iii(i)), [hny hnx 32]);
  hogscale = max(max(hogfeat(:)),max(-hogfeat(:)));
  hogpic = HOGpicture(hogfeat) / hogscale;
  hogpic = imresize(hogpic, [gny gnx]);
  hogpic(hogpic < 0) = 0;
  hogpic(hogpic > 1) = 1;

  pic = cat(2, graypic, hogpic);
  pic = padarray(pic, [bord bord], 1, 'post');

  im((col-1)*cy+1:col*cy, (row-1)*cx+1:row*cx) = pic;
end

im = im(1:end-bord, 1:end-bord);
