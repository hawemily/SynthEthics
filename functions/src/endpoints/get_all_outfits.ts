import { Request, Response } from "express";
import { Collections } from "../helper_components/db_collections";

export const getAllOutfits = async (
  req: Request,
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  const uid = req.params.uid;
  
  const userRef = db.collection(Collections.Users).doc(uid);
  const outfitQuerySnapshot = await userRef.collection(Collections.Outfit).get();
  const outfits: any[] = [];

  const closetRef = userRef.collection(Collections.Closet);

  const dataArray: any[] = [];
  const dataIds: string[] = [];

  outfitQuerySnapshot.forEach((doc) => {
    dataArray.push(doc.data());
    dataIds.push(doc.id);
  });

  const userToDonateRef = userRef.collection(Collections.ToDonate);
  const itemsDonatedQuery = await userToDonateRef.get();

  let donatedItems = new Set();
  itemsDonatedQuery.forEach((doc) => {
    donatedItems.add(doc.id);
  })

  console.log("printing items in donated items set");
  console.log(donatedItems);

  for (var i = 0; i < dataArray.length; i++) {
    let check: boolean = true;
    const data = dataArray[i];
    const clothing = data["clothing"];

    const clothingData = [];
    for (var j = 0; j < clothing.length; j++) {
      const clothingItem = await closetRef.doc(clothing[j]).get();
      if (donatedItems.has(clothing[j])) {
        check = false;
      }
      const jsonObj = { data: clothingItem.data(), id: clothing[j] };
      clothingData.push(jsonObj);
    }

    if (check) {
      data!["clothing"] = clothingData;
      outfits.push({ id: dataIds[i], data: data });
    }
    
  }

  console.log("printing outfits");
  console.log(outfits);

  res.status(200).json({ outfits: outfits });
};
