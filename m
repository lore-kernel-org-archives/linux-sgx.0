Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E56D2E9EC2;
	Tue,  2 Sep 2025 09:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756804281; cv=none; b=g82ayZXu/OIUgHxMRhz2/k6iHXv3j7sZqWvCJxVdgE7vWsm3hDcZH5d4JAfgg1OCcWucSCm1L3xMhqFBOUaMADyrZHR1lAqapklcXG88WYgkulW+OXSSoyJid+6FWAnXg2kU4KmfXyi0J+xdnslLu2al939HDOKLZl6GfPelvfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756804281; c=relaxed/simple;
	bh=schJOHEIfdJWcYpw7eN55EhN7uRYlVT1bTNHtq9v480=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uoACR9fVzUH3hpa4warfJf0ua8hRN8hZ1+lP5AUfo94ZHUgzJlS8zXccOYcKy3dUqPgXhY/5CC6hcTS7aDYXG3vke1+8ILmrUbRL8VX7esf6c07/La60SYrXqrsy0Pqke3G3hnZXjQsZpQiBHT+FcEO5nTtWlKKeByESBOc3DwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=byCo8MVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="byCo8MVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD80C4CEED;
	Tue,  2 Sep 2025 09:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756804280;
	bh=schJOHEIfdJWcYpw7eN55EhN7uRYlVT1bTNHtq9v480=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=byCo8MVI4T0X3R8k9yPbfEvClgcMnHx0ojtLjqKmekCXm8fEwrIFSBQUMTiaIV3VP
	 k7SJ0MeSVjQoVxdz3sO6dkvJZucKJZ4I/9J6NLHewnOyRDA3UG+uksOS+U1miBD1T0
	 3Qse9P6mnxYG1E64jcUOgamQgzwRvoiyI8Wlaom2rvX0jDfIT0VN3oLBki79MONx5R
	 3SlU7pGj4nduCgIK6ELGY+g8578od/OJAfauLIzNVjt+DBGH2kJoHUFllEQW44byGH
	 DKPKw1h+MSKwe+JUd3oOu5IMMvYp6wT+y0PzcmLGaYnxtkzowHhKRi6LDHyP3loMyI
	 NwsRq4P0qnYyg==
Date: Tue, 2 Sep 2025 12:11:16 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"open list:INTEL SGX" <linux-sgx@vger.kernel.org>,
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/sgx: Use guard() instead of mutex_lock() to simplify
 code
Message-ID: <aLa0tE4-Mxsm8k_0@kernel.org>
References: <20250901132229.650658-1-liaoyuanhong@vivo.com>
 <d9a76e90-7723-49ee-b3ec-85c7533d8023@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9a76e90-7723-49ee-b3ec-85c7533d8023@intel.com>

On Mon, Sep 01, 2025 at 11:42:15AM -0700, Dave Hansen wrote:
> On 9/1/25 06:22, Liao Yuanhong wrote:
> > Using guard(mutex) instead of mutex_lock/mutex_unlock pair. Simplifies the
> > error handling to just return in case of error. No need for the 'err_out'
> > label anymore so remove it.
> 
> I don't plan on applying patches like this. Yes, they marginally
> simplify the code, but they do it at the cost of code churn and adding
> new bugs. In other words, they're not worth it.

+1

It has no effect on generated code.

BR, Jarkko
