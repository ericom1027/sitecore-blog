import React from 'react';
import { Field, ImageField, Text, Image } from '@sitecore-jss/sitecore-jss-nextjs';

type BannerProps = {
  fields: {
    Title: Field<string>;
    Text: Field<string>;
    Image: ImageField;
  };
};

const Banner = ({ fields }: BannerProps): JSX.Element => {
  return (
    <section className="w-full bg-[#31323C] py-12">
      <div className="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-10 px-6 md:px-10">
        {fields.Image?.value?.src && (
          <div className="flex-1 flex justify-center md:justify-start items-center order-1">
            <Image
              field={fields.Image}
              className="w-full max-w-md h-auto object-cover rounded-xl shadow-lg"
            />
          </div>
        )}

        <div className="flex-1 text-center md:text-left order-2">
          <h1 className="text-white text-3xl md:text-4xl font-bold mb-4 tracking-wide">
            <Text field={fields.Title} />
          </h1>

          <p className="text-white text-lg leading-relaxed">
            <Text field={fields.Text} />
          </p>
        </div>
      </div>
    </section>
  );
};

export default Banner;
