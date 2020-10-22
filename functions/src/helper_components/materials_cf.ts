const BaseMaterialCF = 10.0;

const MaterialCFRatio: { [key: string]: number } = {
  // place all values for materials here in a dictonary
  
  // conventional materials
  lyocell: 0.5,
  cotton: 1.0,
  linen: 1.0,
  bamboo: 1.3,
  spandex: 1.4,
  polyester: 1.5,
  viscose: 1.5,
  polypropylene: 1.7,
  silk: 1.9,
  hemp: 1.9,
  nylon: 2.2,
  acrylic: 2.6,
  wool: 3.0,
  jute: 5.1,
  leather: 5.5,

  // variants
  polyester_recycled: 1.0,
  cotton_organic: 1.1,
  leather_synthetic: 1.6,
};

// export enum MaterialVariants {
//   ORGANIC = 'organic',
//   RECYCLED = 'recycled',
//   SYNTHETIC = 'synthetic'
// }

export const getMaterialCF = (material: string, variant?: string) => {
  let key = material;
  if (variant) {
    key = key + "_" + variant;
  }

  if (key in MaterialCFRatio) {
    return BaseMaterialCF * MaterialCFRatio[key];
  } else {
    return BaseMaterialCF;
  }
}