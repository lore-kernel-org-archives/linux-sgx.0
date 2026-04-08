Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CAF24169D
	for <linux-sgx@vger.kernel.org>; Wed,  8 Apr 2026 08:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775638695; cv=none; b=XeUTNDcSgWxxLcXh1iwuT0Vx0K9HdOlij3di9SR//HZGybJT5E+UNiYsuL8B6CYO4A98HyNcNCQE9rbIgtrBlu6IGLX0pE7UZXZhJ6xqPmMcJcvF15s9Nt0QxJKl4VqCVQE7uyxIcNltgBePBJr39ClavS0vQKsKxkmBxZNagDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775638695; c=relaxed/simple;
	bh=p76qYCBAR0zGnYEgVoShTRmPP31g+c5I9MiJ2J6gwWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FAhk0NbM363pmoDAZD9wSQI/12YKLWN8G8njIqjWN/m5LddXsNgRU/Yc3z+cXWHqUkwDr+QLLYiMtO9lj+rwIvQnIff6uoBV8pisV8OHYA4QO9Ot2dvFNPv5025VjhgfKlpr9EMUsb8avzBKk1MtnAsNZfQxzNTh8ZmcHIBUcQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m96VA+fH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m96VA+fH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FB0C19424;
	Wed,  8 Apr 2026 08:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775638694;
	bh=p76qYCBAR0zGnYEgVoShTRmPP31g+c5I9MiJ2J6gwWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m96VA+fHwHdBJuljSAWIx3xnYX+eF8nqetBnQ/nOzl0P1ESvEN9bhdVu+c25Kgvrm
	 mzwhQGhUzJc1tBh83c0wZV+HuoHvDQeU+AYmRQLGi5s1qqSD63XiEZ4hk5ArkISJWc
	 Nt2mttEvIpYcgQTQPaUb2hD5UGAeusu59ZREuYznv3O8bnY59YlIQEC8fBkD4t7HLr
	 XGGHAwrINzpD9Jv5a0jDZZ9gssBKl1DnriUhB2O+zFNPFqgVXMH37DwtcIbHUQVJ9p
	 ls42HI65053Z1EwT9nMiJ9v3/jYDS8keLWVud3EWM1UEGi+9RClje6BaITDcwM1HWN
	 GJ9c4e2aYwFjw==
Date: Wed, 8 Apr 2026 11:58:11 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Dingisoul <dingiso.kernel@gmail.com>
Cc: linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
	shuangpeng.kernel@gmail.com
Subject: Re: [BUG] x86/sgx: missing kref_put() in sgx_encl_mm_add() error path
Message-ID: <adYYo727zh6BVGPp@kernel.org>
References: <20260330210957.839878-1-dingiso.kernel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330210957.839878-1-dingiso.kernel@gmail.com>

On Mon, Mar 30, 2026 at 05:09:57PM -0400, Dingisoul wrote:
> Hi Kernel maintainers,
> 
> We found a possible refcount leak in sgx_encl_mm_add().
> 
> In this function, a reference to encl->refcount is taken before registering the MMU notifier:
> 
> /* Grab a refcount for the encl_mm->encl reference: */
> kref_get(&encl->refcount);  // 1. Reference acquired here.
> encl_mm->encl = encl;
> 
> ret = __mmu_notifier_register(&encl_mm->mmu_notifier, mm);
> if (ret) {
> 	kfree(encl_mm);     
> 	return ret;         // 2. Returns without kref_put.
> }
> 
> If __mmu_notifier_register() fails, the function frees encl_mm but does not drop the reference acquired by kref_get(&encl->refcount). This seems to leak one reference to encl.
> 
> Please let us know if the kref_put is unnecessary here.
> 
> Thanks.

It is a leak as encl's, stored in file, will retain increased refcount.

BR, Jarkko
