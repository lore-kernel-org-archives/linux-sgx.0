Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DA22248BB;
	Wed, 16 Apr 2025 19:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744830782; cv=none; b=X2aT3L09XoEJmeSd7HqjqIYde2cLkM9x2fV0gt/UuWfSF0SKXfSqm0a18fyHtfLkHlJuI6ANiL9Jqu9nfO6xFI2pkXoVRpnonkiHlzBv/XcRyhZo/UrDlOpaEHwSUuLFncZz3v3Ex3b9yKsz6L6OzK8/o/EQyJ9qBtcxxYwxtb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744830782; c=relaxed/simple;
	bh=ABo2JdVK46DXWAOKBfrZRMK2GZ5M7loM12Fnkgx9HDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jPey/KDU80ixLkxwXfgDvleZYf/tJSTZDmkkevwugakB/SxXq4I1EkupjrWngjd+yxn3dTTehTJ70LCYdNiGwUfIcQnh2wtV27cMsi/VpMa8SWrwpf9JPBtUE12DYkfg86wmoKRZIcUvSSb+sV+UpTyK0wUperBGRTeIPvX3EIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tejubgSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tejubgSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3161C4CEE2;
	Wed, 16 Apr 2025 19:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744830782;
	bh=ABo2JdVK46DXWAOKBfrZRMK2GZ5M7loM12Fnkgx9HDI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tejubgSR875d+InWKWW3xVU68domAWgY0R2OwfYdVNdiUlO9yjM6A7c2Ts/L9oVnx
	 5g+Pd3sLLxLEJ+xq/UGGFsTG2HzczyTBjLM+PrvHCDHIVr1ltTIQIZiTUtpn0GuRuf
	 OHCLzeej58uk2zhF+/S+i2hhEZTUokILR97EX05doSJdkzlwlTMU1u8reA2xhICXWt
	 HOrY3r3zAlBr+nESRzNcF38fFFHCXUTGxVDCy1X6pN8cEGrpGQ5lZZm+plxcpJD/Nw
	 G/jD1TyAn0paiYWT/JQ+9RwZ02KAa1MhW0NWjzQHvtnswtzhhO/QVnoRi/0/0pyuHA
	 rL0RsnDg4XK4w==
Date: Wed, 16 Apr 2025 22:12:58 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
	chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH v3 1/2] x86/sgx: Use sgx_nr_used_pages for EPC page count
 instead of sgx_nr_free_pages
Message-ID: <aAABOi6OTCidBAeC@kernel.org>
References: <20250415115213.291449-1-elena.reshetova@intel.com>
 <20250415115213.291449-2-elena.reshetova@intel.com>
 <Z__8AHPhZzyhB5A5@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z__8AHPhZzyhB5A5@kernel.org>

On Wed, Apr 16, 2025 at 09:50:44PM +0300, Jarkko Sakkinen wrote:
> On Tue, Apr 15, 2025 at 02:51:21PM +0300, Elena Reshetova wrote:
> > Note: The serialization for sgx_nr_total_pages is not needed because
> > the variable is only updated during the initialization and there's no
> > concurrent access.
> 
> No. It's
> 
> - not a side-note but core part of the rationale.
> - the reasoning here is nonsense, or more like it does not exist at all.
> 
> sgx_nr_free_pages can be substituted with sgx_nr_used_pages at the sites
> where sgx_free_pages was previously used *exactly* because
> sgx_reclaimer_init() is called only after sgx_page_cache_init(). This
> gives the invariant of it to be constant whenever sgx_alloc_epc_page()
> is called.
> 
> These type of changes give a proof of the legitimity of the invariant,
> which I addressed here.

Let's assume that this patch set had a bug just as a mind game.

If we have a reasoning of the change documented, we will end up having
better tools to reason what we did not consider while acking this patch
set per se.

With convoluted reasoning we have absolutely nothing.

This why what I'm saying is important.

BR, Jarkko
