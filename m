Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE9928EA54;
	Thu,  3 Apr 2025 19:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743707566; cv=none; b=l7gKEtFPpWUshsnasa7wf8SGOQg9D8/koiKNlmpDPaeb/9clE3+/wDZssbnIVfimxIJJ8LpnrrN9HrCVdC6Fnza2ToBbK4/kzPsGlZ53Tin0OYourNSZOR9FZ5bGWSQbuUqG7sdEY1tV3zcF89kgHsnSbTG7plhCyTLEPBq1ukw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743707566; c=relaxed/simple;
	bh=ti7BnFPRNxZsXgYT542e+xpuaGAeILN68OLZFikaWow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MuJ7Nwi55rrSHMnur4JDASEU+aYNDbKEHUhDYNFUSWhQznlGZk7d5DZ5fo7YaTEF9rd57heoV/4eFRrKh2f9Cx9WeMIria/n697mhhYk0K85SUs5lfP/CPm2CRsZ9FSgXqaaCOQeeklZuqvQgdOjl0w6ZgzJe3eABCeDiJIFOYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WlgCDi5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WlgCDi5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3C9C4CEE3;
	Thu,  3 Apr 2025 19:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743707566;
	bh=ti7BnFPRNxZsXgYT542e+xpuaGAeILN68OLZFikaWow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WlgCDi5sjxy5cssmx2bWJiubLmFGbFQMqDTYkizHNxGUJR2jr6DZGqKeqUQ9BWM76
	 7pp5KS/oktb7tp879Teyy+sklLOyVdzNZ/tlpVU8CoUcu7IxDuF968QRHEGxPTpoF6
	 c1LjANMobPQSLVbs7CE4Ol4VMeKIfek1MD7uy0TODFQ1RBJw1lXDUH1cLXC7LejF/d
	 ElIItSylmAc881BhB8AkhG+YXDQ4PZyHP0TB8LV0f6BTtyBcnt0aq9nvIpG+QP0mzC
	 4uEhTGu6N5VfClttHIYslj7K2nGQGCRB6EGpUxQTSojJf1SAchg9f1SvY7KFcpgKrk
	 x07NsG1x7FNqw==
Date: Thu, 3 Apr 2025 22:12:41 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Annapurve, Vishal" <vannapurve@google.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"Cai, Chong" <chongc@google.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>,
	"bondarn@google.com" <bondarn@google.com>,
	"Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Message-ID: <Z-7dqQCiu5fWZ9a9@kernel.org>
References: <20250328125859.73803-1-elena.reshetova@intel.com>
 <20250328125859.73803-3-elena.reshetova@intel.com>
 <Z-bhczXA6aHdCYHq@kernel.org>
 <Z-blOQ94ymUsDwPn@kernel.org>
 <DM8PR11MB5750C88DFC518EB77B0D613FE7AD2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-rU_JXWn0vCdBr_@kernel.org>
 <DM8PR11MB5750A46718F899A43C52A984E7AC2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-v4WfcLhmXbYvaa@kernel.org>
 <DM8PR11MB575087BDAFA223EDCE9EC69EE7AF2@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB575087BDAFA223EDCE9EC69EE7AF2@DM8PR11MB5750.namprd11.prod.outlook.com>

On Wed, Apr 02, 2025 at 01:11:25PM +0000, Reshetova, Elena wrote:
> > > current SGX kernel code does not handle such errors in any other way
> > > than notifying that operation failed for other ENCLS leaves. So, I don't
> > > see why ENCLS[EUPDATESVN] should be different from existing behaviour?
> > 
> > While not disagreeing fully (it depends on call site), in some
> > situations it is more difficult to take more preventive actions.
> > 
> > This is a situation where we know that there are *zero* EPC pages in
> > traffic so it is relatively easy to stop the madness, isn't it?
> > 
> > I guess the best action would be make sgx_alloc_epc_page() return
> > consistently -ENOMEM, if the unexpected happens.
> 
> But this would be very misleading imo. We do have memory, even page
> allocation might function as normal in EPC, the only thing that is broken
> can be EUPDATESVN functionality. Returning -ENOMEM in this case seems
> wrong.

This makes it not misleading at all:

	pr_err("EUPDATESVN: unknown error %d\n", ret);

Since hardware should never return this, it indicates a kernel bug.

BR, Jarkko
