Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2ED41509BF;
	Mon, 12 Aug 2024 08:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723450835; cv=none; b=eRUQGM19LAURSX7D3F7IzrhKEbAsrnX6Bba9t9wHGUtp2Lph91EKqPgZxZCYxM1PqtBogYI2R4xHWu/k3UY1d57DW7WcgXYDGmp/SJmZM1HdYPMRL1Qs2u3rIP3wzKON9cpF9R3akrFDPdNLVDHjiTGW6d/KUuCzlavJS1rkDE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723450835; c=relaxed/simple;
	bh=EX1L4c2hRdE+4fXmw1iZfXe8FhjBUBp8qJRQexIrFbs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SW5ItbxFwQlmOHkhgcZ2RDRfpj+lWyuRYT/cuYkIsuHlN56tedbUv1UdtTiczoiLK1k5fY9hAA1WmHiSFVuAPeYO97WOn5nAjDq4WsX0kwe9zl5eyIUJPZmKi3q1LCVNTdsZM3Zn0b+sJMG4bsYCfVYaNCU3blQHqnctNIxQv00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XY7CAPrn; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XY7CAPrn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723450834; x=1754986834;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EX1L4c2hRdE+4fXmw1iZfXe8FhjBUBp8qJRQexIrFbs=;
  b=XY7CAPrnBGkgdiLjP9CprZ1DeWP7B/guoy5yGgWMAFLT4UoMpiKhITtH
   Gg8XnRkMoVa9inzvrL2HBwuSlGZ9cWBsSy9ApEIA42kuLSdCmCYnQre9P
   ARXMTZJR0HubZwD3VlN2lwae2fiLNIm1GKHEpuEdJhCYy4h3RyNdFVbvO
   EI0/AYmCTwapPpijDmcNxNFOEcomybbTOdAGDMHaVP2Dsq7zlRP3hcD9x
   Nd2PCMgy3SQL+EBw09FfMKniXkH9EuWlYxjejZ7auw0BIAMWNnU3dyYN8
   xWzNuXVWBLHx61+LxBAUwVTpQw+mSJt7zz8PuKQu4Q61stxYpBJNFsW34
   g==;
X-CSE-ConnectionGUID: fUBVIRGaTnOqVsv2Etu1ww==
X-CSE-MsgGUID: b/0j15KFRZaOAkGxG/Aa9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11161"; a="39058044"
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="39058044"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 01:20:33 -0700
X-CSE-ConnectionGUID: 1qUq4VSbS46lupfKjbfWvg==
X-CSE-MsgGUID: jX3vBmJ4ShKYwBCSCtXR2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="57844644"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 01:20:33 -0700
From: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
To: jarkko@kernel.org
Cc: dave.hansen@linux.intel.com,
	dmitrii.kuvaiskii@intel.com,
	haitao.huang@linux.intel.com,
	kai.huang@intel.com,
	kailun.qin@intel.com,
	linux-kernel@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	mona.vij@intel.com,
	reinette.chatre@intel.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v4 1/3] x86/sgx: Split SGX_ENCL_PAGE_BEING_RECLAIMED into two flags
Date: Mon, 12 Aug 2024 01:12:16 -0700
Message-Id: <20240812081216.3006639-1-dmitrii.kuvaiskii@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <D2RQXM679U0X.1XY6BWHSFTRFZ@kernel.org>
References: <D2RQXM679U0X.1XY6BWHSFTRFZ@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Deutschland GmbH - Registered Address: Am Campeon 10, 85579 Neubiberg, Germany
Content-Transfer-Encoding: 8bit

On Wed, Jul 17, 2024 at 01:36:08PM +0300, Jarkko Sakkinen wrote:
> On Fri Jul 5, 2024 at 10:45 AM EEST, Dmitrii Kuvaiskii wrote:
> > SGX_ENCL_PAGE_BEING_RECLAIMED flag is set when the enclave page is being
> > reclaimed (moved to the backing store). This flag however has two
> > logical meanings:
>           ~~~~~~~~
>         side-effects

Could you clarify the required action here? Do you expect me to replace
"This flag however has two logical meanings" with "This flag however has
two logical side-effects"? The suggested word doesn't seem to apply nicely
to this case. In my text, I have the following two sentences: "Don't
attempt to load the enclave page" and "Don't attempt to remove the PCMD
page ...". I don't think it's proper English to say that "Don't attempt
..." is a side effect. Or do you want me to also modify the two sentences
in the list?

By the way, this text is a rephrasing of Dave Hansen's comment:
https://lore.kernel.org/all/1d405428-3847-4862-b146-dd57711c881e@intel.com/

> > To reflect these two meanings, split SGX_ENCL_PAGE_BEING_RECLAIMED into
>
> I don't care about meanings. Only who does and what.

Could you clarify the required action here? What would be a better
rephrasing? Aren't we supposed to clarify the rationale behind the code
changes in the commit message?

--
Dmitrii Kuvaiskii
