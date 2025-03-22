Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B226AAD;
	Sat, 22 Mar 2025 22:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742681462; cv=none; b=Mwa2HSoKUYIOft1fx3d1dVxi4aaQ9QsB0Z/S6fca5TYM1WaMVEMH24zhNJddfemcspJFNdKqeR5OQCO6RACUDTT9Wypl0gQOasnEIb1joSvoXWB99jKPpNzJFjLi1sfRR1sw1uT25A3apuA5wLHuz6BOBya1IVUnGlfJIsHSfv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742681462; c=relaxed/simple;
	bh=PqQSsreBQuaNw0UX/YhcSGAZiARc4QkVUQvBMlqAdK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QoPquabE2PWzLuADnXhEPgWYXq05rWh2AdnXr2zAjiMMtX+OZksBujpbMNU780ACEsfo/If9d+erVJptN4fH0G8/DaVaO7eHjszZDxf4J7VbzmTWR6PTVKzGPdv2Mi8whZH0j/7SwSj70D/Ydcs5BhaollUCS0oCcnUZtDLiXJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s3SlGMAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s3SlGMAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5249C4CEDD;
	Sat, 22 Mar 2025 22:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742681462;
	bh=PqQSsreBQuaNw0UX/YhcSGAZiARc4QkVUQvBMlqAdK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s3SlGMAuob98rG4+h8QJGbmunfWfNQ4p8x4m5KjHjfgpZB8kBpwa0ZBdkbZICZcIs
	 Ko7v6S1lJs9qrJ+qvYxsP7AB5gGc5Daepn3RTbG05cLja71J3so5IwpYRefKcErUBn
	 en0IkiS0CBI14jldTX7xiIvkSHuopVBwFkWP7q8fMp+K+La4FA4xoKyW7SiNKSAA+T
	 qhVleKJ34ggj0N2gqUGRUQuLX63ytSHCu1aJrg2xKkK+2UZUrQWSiVBHkUqiKJFUgB
	 u7ijplFnnh7QmsNVuecvfHtISuZtxUrKIpO2abCE6+dke6vUjJ5YASgbmWCiQaIWz+
	 adK2C9whKy7og==
Date: Sun, 23 Mar 2025 00:10:58 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
	chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH 2/4] x86/sgx: Change counter sgx_nr_free_pages ->
 sgx_nr_used_pages
Message-ID: <Z981ciAqpknQ3hRF@kernel.org>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-3-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321123938.802763-3-elena.reshetova@intel.com>

On Fri, Mar 21, 2025 at 02:34:41PM +0200, Elena Reshetova wrote:
> sgx_nr_free_pages is an atomic that is used to keep track of
> free EPC pages and detect whenever page reclaiming should start.
> Since successful execution of ENCLS[EUPDATESVN] requires empty
> EPC and a fast way of checking for this, change this variable
> around to indicate number of used pages instead. The subsequent
> patch that introduces ENCLS[EUPDATESVN] will take use of this change.

s/subsequent patch//

You should rather express how EUPDATESVN trigger will depend on the
state of sgx_nr_used_pages and sgx_nr_free_pages.

> 
> No functional changes intended.

Not really understanding how I should interpret this sentence.

The commit message does not mention sgx_nr_used_pages, and neiher it
makes a case why implementing the feature based on sgx_nr_free_pages is
not possible.

BR, Jarkko
