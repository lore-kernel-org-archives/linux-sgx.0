Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C7E2F3B;
	Fri, 28 Mar 2025 08:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743151339; cv=none; b=pvNnANbK4Bn7AkzcFLZz/t3BadWhSKmo7QihtdZ4QXp7ihHzeV5Gdq7HlQhlZPPrBpBAc1dq9ZU4c8mD24YoPEo3zKxb269DElEfENd+pSD6HNKVEXHDI3hIMII0DRpHJIpuz9vTUfWivSnZX2Hzbbo6GiKdJwZ3u3dsI7QbWOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743151339; c=relaxed/simple;
	bh=k0qzpOEDNHHwkiakQUtLiR7PFcSlBuDqKJEADqMx+Mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qpc3zPjhBYnaEIClJeeq1dSIGhFvbwayMlLkAJHG/+F1JdYTm9/dEMExY/ie62ZSOGlTm7HdzhKztC6j0k+xd/72reyUNDSQvkI1GdhYEfiTY3R1OmKkA7Ud9YbVoGiK+wiNswMnVCbtX2XAINcHKkZiuhMVDlANjnTKHxtRsg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SHQqwWQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SHQqwWQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9381CC4CEE4;
	Fri, 28 Mar 2025 08:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743151338;
	bh=k0qzpOEDNHHwkiakQUtLiR7PFcSlBuDqKJEADqMx+Mw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SHQqwWQtMX/vawGvLyoSFHNFAD8Yvio6oTDQ27k2bZ32UxRCp84jHfOmThT/3lmQ/
	 U+bVct+L0EhZcCUJtEnb/v+78V6ME2Yff88fMXdID7NxVwa3SgFA9xNqVIdHwaQ2b4
	 OLY2nBjmmcBXnXMsUBw2zpoLDbipwUC4oZ02Pwn+o8oUlKrRbJ2cfMMSkA78Jx3F4z
	 I5yPVPEFbKQ1QUPCJFT5vKPZ7ivH51nUhZ9y00TA/AA87fQbSadjUxH7nuqDUV5E8z
	 jrQOXJ1+ufsRObAT1ZH7fOEZxpZ1ejvbjuXm/PlHtyKJFFgqnskO3/FjL+BINuFKmp
	 GYIDPX/fK+mVg==
Date: Fri, 28 Mar 2025 10:42:13 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Hansen, Dave" <dave.hansen@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"Cai, Chong" <chongc@google.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>,
	"bondarn@google.com" <bondarn@google.com>,
	"Raynor, Scott" <scott.raynor@intel.com>,
	"Shutemov, Kirill" <kirill.shutemov@intel.com>
Subject: Re: [PATCH 1/4] x86/sgx: Add total number of EPC pages
Message-ID: <Z-Zg5elc0xTwoxat@kernel.org>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-2-elena.reshetova@intel.com>
 <Z98yki-gH4ewlpbP@kernel.org>
 <DM8PR11MB57508A3681C614C9B185B04EE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-RY8-bL2snpRKTB@kernel.org>
 <DM8PR11MB575029FAC2C833553CE422CFE7A12@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-XDFDj8Tc5i-GBg@kernel.org>
 <DM8PR11MB57503621B1D7674404A62004E7A02@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB57503621B1D7674404A62004E7A02@DM8PR11MB5750.namprd11.prod.outlook.com>

On Fri, Mar 28, 2025 at 08:07:24AM +0000, Reshetova, Elena wrote:
> > Yes but obviously I cannot promise that I'll accept this as it is
> > until I see the final version
> 
> Are you saying you prefer *this version with spinlock* vs. 
> simpler version that utilizes the fact that sgx_nr_free_pages is changed
> into tracking of number of used pages? 

I don't know really what I do prefer.

Maybe +1 version would make sense where you keep with the approach
you've chosen (used pages) and better rationalize why it is mandatory,
and why free pages would be worse?

> 
> > 
> > Also you probably should use mutex given the loop where we cannot
> > temporarily exit the lock (like e.g. in keyrings gc we can).
> 
> Not sure I understand this, could you please elaborate why do I need an
> additional mutex here? Or are you suggesting switching spinlock to mutex? 

In your code example you had a loop inside spinlock, which was based on
a return code of an opcode, i.e. potentially infinite loop.

I'd like to remind you that the hardware I have is NUC7 from 2018 so
you really have to nail how things will work semantically as I can
only think these things only in theoretical level ;-) [1]


> 
> Best Regards,
> Elena.
> 

[1] https://social.kernel.org/notice/AsUbsYH0T4bTcUSdUW

BR, Jarkko
