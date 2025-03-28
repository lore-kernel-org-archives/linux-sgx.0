Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E0321147B;
	Fri, 28 Mar 2025 09:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743153113; cv=none; b=USynHTtXOL7rTlZnJHeqQpcpwui+2V4kPEGJ737Fi6GZ1VciPF4Bl5tqu+KH3G91JhJE6iDaMDQy1yirijw2e6nbNjpeF8Xkq0bnCY1biWxCbX/Qs4IzT8Yset39j/M94d4QQY6yR2OuZE8aQ/nJWGzn2ZUOmmIiu7yde/b/FSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743153113; c=relaxed/simple;
	bh=2GkOWaiNXqyl/OL1u4jIroUOUPz9+n3zuRyiquvPGmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BI6xfLszU40eiiiLAhLqdt6OfH+Q8Y0FeAE0t5Mn6dTmC39liXP/DfqV3MBQO1S1qsf0F/QBK5gs1awUvJ6RzvkvAIi93bs2D+zitIpd7khxgm4CdremDj7+OZmXPdLZS3UwPNPNStX6vgLpEYJA0OgDEWFKjRV5ZiQqcrbtNf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eQGCzkno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eQGCzkno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4433C4CEE4;
	Fri, 28 Mar 2025 09:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743153113;
	bh=2GkOWaiNXqyl/OL1u4jIroUOUPz9+n3zuRyiquvPGmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eQGCzknoEr4PqQd5wXayvDTwMH4ZMsCsAgM4+iw8ojYWOXV/VHEw04MoIKPNQMR8V
	 /o3NDi4KT4lzfAwmBQmbXfEbyY0YFQxF26IL9bnt63oL1fAyRLSEDP2ubvQSNg4XQV
	 FRELpHNyNgc6iH04qPSLy7KU/6dl1UerO1pmGTI/bnRXrEaf2ltp8T50gYW4bj0RA+
	 4FsPC/ZwcHRgTLdtlfh5O0HKXuE8kQq+ia0X4RDwT78wLF1EAxp1TIMvVtPrNzmvkQ
	 6E7xD/R4Gr8BXia6Eb91Xj9vcTX53F04OosWV7O0wvVMk31wv+gQky6vnThmghKeXk
	 rTbEh2ra6gD5w==
Date: Fri, 28 Mar 2025 11:11:48 +0200
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
Message-ID: <Z-Zn1KkNTNCGvEcj@kernel.org>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-2-elena.reshetova@intel.com>
 <Z98yki-gH4ewlpbP@kernel.org>
 <DM8PR11MB57508A3681C614C9B185B04EE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-RY8-bL2snpRKTB@kernel.org>
 <DM8PR11MB575029FAC2C833553CE422CFE7A12@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-XDFDj8Tc5i-GBg@kernel.org>
 <DM8PR11MB57503621B1D7674404A62004E7A02@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-Zg5elc0xTwoxat@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-Zg5elc0xTwoxat@kernel.org>

On Fri, Mar 28, 2025 at 10:42:18AM +0200, Jarkko Sakkinen wrote:
> In your code example you had a loop inside spinlock, which was based on
> a return code of an opcode, i.e. potentially infinite loop.
> 
> I'd like to remind you that the hardware I have is NUC7 from 2018 so
> you really have to nail how things will work semantically as I can
> only think these things only in theoretical level ;-) [1]

That said, I do execute these in NUC7 but is getting a bit old..

Cheapest hardware I've heard is Xeon E-2334 but even that with
case etc. is like nearing 2k in price.

BR, Jarkko
