Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8941B2DC770;
	Wed, 30 Apr 2025 15:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746026186; cv=none; b=IJczuzo1Dmk4IT+aGywYujSV+HcZBw5OXnWfEj/CRBORndWfJxiuNERMy/aNKrfVJZwkTRAFD1bApXs6GXUkBtWNli7wP1+z8mfLHbbkemL36Kwbo/ZGaeGVSIa6SE5rTccyMVblgF1ZBUloOINXQMlm4VnesE4wHI5U6o0PJkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746026186; c=relaxed/simple;
	bh=ttE3sHexDRAFmrcQqUiwsk+71nttsmLhwmVo1OAt7Hg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jp10+M8C+GEkYP+x5eHZ5H/eQnByQt4ikWG0WfOb/HIATlmwfkNtjfa3OSAzo/KA/pXk8ewkdCcqDv+zfV2ZjRmy1BW3Z7O70Nxpijua7V+sbQf1o/LA6PgzGZEdK3udLkSSd6iKE1AqAXiidRC58YHJ6sp2Jc7nsRbeD2ijb6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DvhRgt58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DvhRgt58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBC3C4CEE7;
	Wed, 30 Apr 2025 15:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746026186;
	bh=ttE3sHexDRAFmrcQqUiwsk+71nttsmLhwmVo1OAt7Hg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DvhRgt58tN19SSfK2+EAbkO3AE73rZHsBsXTJrj8M80KRzi6RoRRGoaqZUXgOh0tr
	 3pGuLtybBhrxk6/pB9g3m6HKKzPIu48m4MvhMYhpQGCtmJsvs4jjcNDsDZcmt6DeET
	 qT23czBnKG2hpq0qBmq3CfbA32/UhtDniygBLVT/0nd3CUqezY1FrFbP10tEIwFk96
	 a4aWnwNjF9xDqBWWnhgVPNCZZmvgb/jwPaAHN52p6nbcrF246Ir9IZkZcQ+igE1hBY
	 7XyOJjt9P5CCDEkcACuv+ZGDXiU/VRB4OnNQtRIVSKcXVXMeLOagNKpeFDw9Cs088c
	 11gzEP0hw9HDg==
Date: Wed, 30 Apr 2025 18:16:21 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Hansen, Dave" <dave.hansen@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>,
	"Cai, Chong" <chongc@google.com>,
	"Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bondarn@google.com" <bondarn@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>,
	"Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Message-ID: <aBI-xQzatja2Y9dh@kernel.org>
References: <0d7d6b9a-e7bd-4225-8f08-05bd9473a894@intel.com>
 <aAviqeAdGn-w1GpK@google.com>
 <fbd2acdb-35dc-4e8c-9bd9-e84264f88648@intel.com>
 <aAv445Sr71NUJP1X@google.com>
 <db1fd062-5a66-4942-82e2-c889dd645a7b@intel.com>
 <aAwFhaqQDLXoqbmv@google.com>
 <4b4ecaa1-2ace-43bf-b71b-0de78bcf113c@intel.com>
 <DM8PR11MB5750B39557F5062038D0E551E7802@DM8PR11MB5750.namprd11.prod.outlook.com>
 <8db47bc1-445b-49db-b932-96aff0eb58a9@intel.com>
 <DM8PR11MB5750200DFF8CF40E3539B688E7832@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB5750200DFF8CF40E3539B688E7832@DM8PR11MB5750.namprd11.prod.outlook.com>

On Wed, Apr 30, 2025 at 06:53:32AM +0000, Reshetova, Elena wrote:
> 2. Switch to Sean's approach to execute EUPDATESVN during the sgx_open().
> Btw, Sean do you agree that we don't gain much doing it second time during
> release() given the microcode flow?
> I would rather leave only one invocation of eupdatesvn during sgx_inc_usage_count().
> 
> Proc: No new uABI. More predictable on svn change compared to option 1.

> Cons: Two explicit paths to hook: sgx_open() and sgx_vepc_open(). 

Why this is a con?

BR, Jarkko
