Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8038A26563F;
	Tue, 11 Feb 2025 21:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739307841; cv=none; b=FWiRWU39jl7MthKcON06CyaFMfZstoUa4tVqww47fPjR9Vqxj5YcjaPvihvyjmED7BezRU+bd3X728ObGJqj8RZSWao8JIplBdONONRP2t3XJz3UCJIgVbJdXL2a6xTXV4nbXJ+DoQQdoKScuCyXK+GI+LompZ4DOenKzfJawbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739307841; c=relaxed/simple;
	bh=6j5FNlgJVcpM/IJtuYfK4W9GFgPKmKTMIYeOXYy5vxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mIPauDolqD7xRq/klp2EDWHQGcMF7wH8mn0xMnrLGklWNEeHm6WOWMGrSOGaPN+DaGeeTX4L47w+m0Z1hffPUrRCxVCFSNuGrbDVDc2WNo7wpx+OY78bIO7iy2lxC2PM0cmeX+wnJ0w1qmg8neDwlXBou4R9P+sWaaxeRrky9ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZtdLz5hG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZtdLz5hG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A72DC4CEE2;
	Tue, 11 Feb 2025 21:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739307841;
	bh=6j5FNlgJVcpM/IJtuYfK4W9GFgPKmKTMIYeOXYy5vxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZtdLz5hG7r3OoK+MoLNtVDibs+sKbpaYjDHg/gzAh/paF2Mks8YaV8Ykg/WzjeVjn
	 wY3H9JMYFCo/3fwZ1XlgYWm1/1oBTSHkLYbtruIO2nPtxRwDgqKUBqsRkVU1R3udNp
	 O93DfR/61OWXk0ZnL0UskuLWe81swc2lOQjIVNMGUnAHOCsSfoLLz1e3z5CE7GQ5Ki
	 ob8qQwa9UZ+SvzZK5MS64gNPFKkzrdZq5sXZhJljzXxN+4Swr2D4Zo1UdnaBGnqU/l
	 cEXqmqMSNLt5j5ygCxf+vJBqb6OJay48Pqw7ElQ0y80o8sSna49RKbNa7ymeZx9qZb
	 6lq0R8envsZow==
Date: Tue, 11 Feb 2025 23:03:56 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andrew Zaborowski <andrew.zaborowski@intel.com>, x86@kernel.org,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>, balrogg@gmail.com
Subject: Re: [PATCH] x86: sgx: Don't track poisoned pages for reclaiming
Message-ID: <Z6u7PEQKb-L8X4e6@kernel.org>
References: <20250211150150.519006-1-andrew.zaborowski@intel.com>
 <3bd497be-54d7-43b8-a392-4bf82bf64679@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bd497be-54d7-43b8-a392-4bf82bf64679@intel.com>

On Tue, Feb 11, 2025 at 08:25:58AM -0800, Dave Hansen wrote:
> > arch_memory_failure() but stay on sgx_active_page_list.
> > page->poison is not checked in the reclaimer logic meaning that a page could be
> > reclaimed and go through ETRACK, EBLOCK and EWB.  This can lead to the
> > firmware receiving and MCE in one of those operations and going into
> > "unbreakable shutdown" and triggering a kernel panic on remaining cores.
> 
> This requires low-level SGX implementation knowledge to fully
> understand. Both what "ETRACK, EBLOCK and EWB" are in the first place,
> how they are involved in reclaim and also why EREMOVE doesn't lead to
> the same fate.

Does it? [I'll dig up Intel SDM to check this]

BR, Jarkko
