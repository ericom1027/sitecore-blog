import React from 'react';
import { Field, Text } from '@sitecore-jss/sitecore-jss-nextjs';

interface NavigationItem {
  url: string | undefined;
  fields: {
    NavigationTitle: Field<string>;
  };
}

interface NavbarProps {
  fields?: {
    Title: Field<string>;
    NavigationItem: NavigationItem[];
  };
}

const Navbar = ({ fields }: NavbarProps) => {
  return (
    <header className="bg-blue-800 px-8 py-6">
      <div className="max-w-7xl mx-auto flex flex-col items-start">
        <h2 className="text-white text-3xl md:text-4xl font-bold mb-4">
          <Text field={fields?.Title} />
        </h2>

        <nav>
          <ul className="flex flex-col md:flex-row md:gap-6 gap-4">
            {fields?.NavigationItem.map((item, index) => (
              <li key={index}>
                <a
                  href={item.url}
                  className="text-white no-underline hover:text-blue-400 transition-colors duration-300 block"
                >
                  <Text field={item.fields.NavigationTitle} />
                </a>
              </li>
            ))}
          </ul>
        </nav>
      </div>
    </header>
  );
};

export default Navbar;
