import React from 'react';
import Link from 'next/link';
import { Field, ImageField, LinkField, Text, Image } from '@sitecore-jss/sitecore-jss-nextjs';

type CardProps = {
  image: ImageField;
  text: Field<string>;
  caption?: Field<string>;
  link?: LinkField;
};

const Card = ({ image, text, caption, link }: CardProps): JSX.Element | null => {
  if (!image?.value?.src) return null;

  const href = link?.value?.href || '#';
  const target = link?.value?.target || '_self';

  return (
    <Link href={href} target={target} passHref>
      <div
        className="bg-white rounded-xl shadow-lg p-4 flex flex-col items-center 
                   transition-transform duration-300 hover:scale-105 hover:shadow-xl cursor-pointer"
      >
        <Image field={image} className="w-full h-40 object-cover rounded-md" />

        <p className="mt-3 text-gray-800 text-md text-center">
          <Text field={text} />
        </p>

        {caption && (
          <p className="mt-2 text-xs text-gray-600 italic text-center">
            <Text field={caption} />
          </p>
        )}
      </div>
    </Link>
  );
};

export default Card;
