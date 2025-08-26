import { Field, ImageField, Image, RichText } from '@sitecore-jss/sitecore-jss-nextjs';
import React from 'react';

type AboutProps = {
  fields: {
    Content: Field<string>;
    AboutImage?: ImageField;
  };
};

function About({ fields }: AboutProps): JSX.Element {
  return (
    <section className="w-full bg-gray-100 text-gray-900 py-16 px-6 md:px-[150px]">
      <div className="flex flex-col md:flex-row items-center gap-10 bg-white rounded-2xl shadow-xl p-10">
        {fields?.AboutImage && (
          <div className="w-full md:w-1/2">
            <Image
              field={fields.AboutImage}
              className="rounded-xl object-cover w-full h-auto max-h-[400px] shadow-md"
            />
          </div>
        )}

        <div className="w-full md:w-1/2">
          <RichText
            field={fields?.Content}
            className="text-gray-700 text-base md:text-lg leading-relaxed space-y-4"
          />
        </div>
      </div>
    </section>
  );
}

export default About;
