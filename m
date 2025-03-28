Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014B32F3B;
	Fri, 28 Mar 2025 08:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743151471; cv=none; b=noMjuZtUJ0ueMneFM0TK3VOOaHsKkEeFI5E7tVCSxcUeGCc7T+l+pb0xof6lx8faEOa2mbNruhTx+k7WM42RvQX88PU767aZLanECyuC8TCcnj/jOEiZAhxmOvxxRJh98UDVeO4RtRtCK/t1dRXVEvZT2Q2kP219eBQlsoJYBcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743151471; c=relaxed/simple;
	bh=7wWpNyqwEltt65jw58fWm4t4+DezGpJMXEf4es9UZBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EGRXHX85iBOtapWOuynHkRUPQdovIEPFQ0XcrIgNZWs/kz6zSUQE2daCHPjhurKTMldyhTo9rMBKEMCPZEyAbYXXEkfilAY2q0Uht6QYQu3B7SHrs0vqLWDsd7kWSjS9qmc7VnqEhdTJcx1ljukHT6NF2aTkUiKUGRVjDKNMKZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tvTNG3yn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tvTNG3yn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A74C4CEE4;
	Fri, 28 Mar 2025 08:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743151470;
	bh=7wWpNyqwEltt65jw58fWm4t4+DezGpJMXEf4es9UZBc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tvTNG3ynFho3DH3Rp+RztQH5CP6x6aaH8VICHj0go9wqjxsHobhsynnpkpPy9WyRt
	 brtW0jv8aWTkISaBem9nA3B/VxeLrGW5BlfjCgFfnIhHgf4A+rixw8/VAqAaiJYIUG
	 bzbgSggRp6XRxuKKNjxcHr1yA9g837AW05R3Wk+aQDZMhZ0DMVSkfPqyLKjoUfeiQs
	 2QzqwyxmTqVMDkqKK/bKpKaouPi0kjmhc3UFv0yzvso7Euz8c+4HpSyCik9ZxYvAYc
	 /zDcn4l75GL5HD13etXK4nh5tWqove7kr5dMUTXUr78SVy3OTLIVON43SjScQZYX+W
	 pevz5T/lNZMHw==
Date: Fri, 28 Mar 2025 10:44:25 +0200
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
	"Zhang, Cathy" <cathy.zhang@intel.com>
Subject: Re: [PATCH 4/4] x86/sgx: Implement ENCLS[EUPDATESVN] and
 opportunistically call it during first EPC page alloc
Message-ID: <Z-ZhaagOPj8bhCCo@kernel.org>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-5-elena.reshetova@intel.com>
 <Z983ZaTaWNqFUpYS@kernel.org>
 <DM8PR11MB575000AEB9CC3A318651AAABE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-RfcpSBAybk-KjG@kernel.org>
 <DM8PR11MB5750FE25D4C8EC2297952845E7A12@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-XA0oy_r9VBJPHI@kernel.org>
 <DM8PR11MB57501BCC966906CB02946986E7A02@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB57501BCC966906CB02946986E7A02@DM8PR11MB5750.namprd11.prod.outlook.com>

On Fri, Mar 28, 2025 at 08:27:51AM +0000, Reshetova, Elena wrote:
> 
> > On Thu, Mar 27, 2025 at 03:42:30PM +0000, Reshetova, Elena wrote:
> > > > > > > +	case SGX_NO_UPDATE:
> > > > > > > +		pr_debug("EUPDATESVN was successful, but CPUSVN
> > was not
> > > > > > updated, "
> > > > > > > +			"because current SVN was not newer than
> > > > > > CPUSVN.\n");
> > > > > > > +		break;
> > > > > > > +	case SGX_EPC_NOT_READY:
> > > > > > > +		pr_debug("EPC is not ready for SVN update.");
> > > > > > > +		break;
> > > > > > > +	case SGX_INSUFFICIENT_ENTROPY:
> > > > > > > +		pr_debug("CPUSVN update is failed due to Insufficient
> > > > > > entropy in RNG, "
> > > > > > > +			"please try it later.\n");
> > > > > > > +		break;
> > > > > > > +	case SGX_EPC_PAGE_CONFLICT:
> > > > > > > +		pr_debug("CPUSVN update is failed due to
> > concurrency
> > > > > > violation, please "
> > > > > > > +			"stop running any other ENCLS leaf and try it
> > > > > > later.\n");
> > > > > > > +		break;
> > > > > > > +	default:
> > > > > > > +		break;
> > > > > >
> > > > > > Remove pr_debug() statements.
> > > > >
> > > > > This I am not sure it is good idea. I think it would be useful for system
> > > > > admins to have a way to see that update either happened or not.
> > > > > It is true that you can find this out by requesting a new SGX attestation
> > > > > quote (and see if newer SVN is used), but it is not the faster way.
> > > >
> > > > Maybe pr_debug() is them wrong level if they are meant for sysadmins?
> > > >
> > > > I mean these should not happen in normal behavior like ever? As
> > > > pr_debug() I don't really grab this.
> > >
> > > SGX_NO_UPDATE will absolutely happen normally all the time.
> > > Since EUPDATESVN is executed every time EPC is empty, this is the
> > > most common code you will get back (because microcode updates are rare).
> > > Others yes, that would indicate some error condition.
> > > So, what is the pr_level that you would suggest?
> > 
> > Right, got it. That changes my conclusions:
> > 
> > So I'd reformulate it like:
> > 
> > 	switch (ret) {
> > 	case 0:
> > 		pr_info("EUPDATESVN: success\n);
> > 		break;
> > 	case SGX_EPC_NOT_READY:
> > 	case SGX_INSUFFICIENT_ENTROPY:
> > 	case SGX_EPC_PAGE_CONFLICT:
> > 		pr_err("EUPDATESVN: error %d\n", ret);
> > 		/* TODO: block/teardown driver? */
> > 		break;
> > 	case SGX_NO_UPDATE:
> > 		break;
> > 	default:
> > 		pr_err("EUPDATESVN: unknown error %d\n", ret);
> > 		/* TODO: block/teardown driver? */
> > 		break;
> > 	}
> > 
> > Since when this is executed EPC usage is zero error cases should block
> > or teardown SGX driver, presuming that they are because of either
> > incorrect driver state or spurious error code.
> 
> I agree with the above, but not sure at all about the blocking/teardown the
> driver. They are all potentially temporal things and  SGX_INSUFFICIENT_ENTROPY
> is even outside of SGX driver control and *does not* indicate any error
> condition on the driver side itself. SGX_EPC_NOT_READY and SGX_EPC_PAGE_CONFLICT
> would mean we have a bug somewhere because we thought we could go
> do EUDPATESVN on empty EPC and prevented anyone from creating
> pages in meanwhile but looks like we missed smth. That said, I dont know if we
> want to fail the whole system in case we have such a code bug, this is very 
> aggressive (in case it is some rare edge condition that no one knew about or
> guessed). So, I would propose to print the pr_err() as you have above but
> avoid destroying the driver. 
> Would this work? 

I think now is the time that you should really roll out a new version in
the way you see fit and we will revisit that.

I already grabbed from your example that I got some of the error codes
horribly wrong :-) Still I think the draft of error planning I put is
at least towards right direction.

> 
> Best Regards,
> Elena.
> 
> 
> > 
> > If this happens, we definitely do not want service, right?
> > 
> > I'm not sure of all error codes how serious they are, or are all of them
> > consequence of incorrectly working driver.
> > 
> > BR, Jarkko

BR, Jarkko
