Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91791CD31;
	Thu,  5 Sep 2024 14:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725546303; cv=none; b=P2y+HAyptVbGtkyQ0888AuLEpHxjO2RE/ZkwXEYbWEC/l+uAgcJhzCG28TCvwNL2Dj6G/jIFUdm1IcKLVxTwsoTY5JRf/7eaZpm6YBPjlTaba0uVkDZQ9aMBM/DWsjvg7KBFmr5BOP+EDZgIOfn+Lun3SKpqTEJk2Ne6sWy83Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725546303; c=relaxed/simple;
	bh=+Bq6w2jXjyGRfOCfPjEWfgXkJQ+bI6xdE5IijUSIabM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=W36AvungPOlLLyaMN9xIajClgBeIdZNx4T+5520Rg8MX8xhWCSwMgukl2hPeRz4xFP8LMkpsEMuGgjLuWdIECF1y95yd2WnqDEjdyXNplz9Cr76eL0hWHJGFovF0fMvobgb7fEkVFKa3H+YJ4dgxKGgjAoCaSqgHALa6LsJ2V/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CaDwJpPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CaDwJpPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91C3C4CEC3;
	Thu,  5 Sep 2024 14:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725546303;
	bh=+Bq6w2jXjyGRfOCfPjEWfgXkJQ+bI6xdE5IijUSIabM=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=CaDwJpPD+AvPyXrQ1NNVMkWFjbd7b8K8KIwsGPyH+kcDi62RxMXThveUuNIyijfZu
	 W/TrsTdNzBR0+fOlrw+3wrYpF0uLr9nixQd3cfV0q3BfDzkXtPzgoNIR6yBHBQGc7U
	 QeDL7pDjTPJxKkLJO/yvUTX8twI4zYTRBrU8LEN8fvYlaH1xv2CeLYWDHl7v32/q9N
	 27ZtqJ6IBc8XOhmwsswkUcKncahaIgw2x5jSKzIRsk+gn66eVG+dWMU0HbgAdcJgl/
	 PGzdDJOwP8CNE70fmakUGhodwPScQlpZDZjyRV+2I0Z/0p192CEGvsKAPZ/cjP4Qqc
	 dEUrBqKYdSpgQ==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 05 Sep 2024 17:24:59 +0300
Message-Id: <D3YF42L6VP2I.12ZOBQPIPQ2BA@kernel.org>
Subject: Re: [PATCH v2 2/2] x86/sgx: Log information when a node lacks an
 EPC section
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Aaron Lu" <aaron.lu@intel.com>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Kai Huang" <kai.huang@intel.com>
Cc: "Molina Sabido, Gerardo" <gerardo.molina.sabido@intel.com>, "Zhimin Luo"
 <zhimin.luo@intel.com>, <linux-sgx@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <x86@kernel.org>
X-Mailer: aerc 0.18.2
References: <20240905080855.1699814-1-aaron.lu@intel.com>
 <20240905080855.1699814-3-aaron.lu@intel.com>
In-Reply-To: <20240905080855.1699814-3-aaron.lu@intel.com>

On Thu Sep 5, 2024 at 11:08 AM EEST, Aaron Lu wrote:
> For optimized performance, firmware typically distributes EPC sections
> evenly across different NUMA nodes. However, there are scenarios where
> a node may have both CPUs and memory but no EPC section configured. For
> example, in an 8-socket system with a Sub-Numa-Cluster=3D2 setup, there
> are a total of 16 nodes. Given that the maximum number of supported EPC
> sections is 8, it is simply not feasible to assign one EPC section to
> each node. This configuration is not incorrect - SGX will still operate
> correctly; it is just not optimized from a NUMA standpoint.
>
> For this reason, log a message when a node with both CPUs and memory
> lacks an EPC section. This will provide users with a hint as to why they
> might be experiencing less-than-ideal performance when running SGX
> enclaves.
>
> Suggested-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/mai=
n.c
> index 694fcf7a5e3a..3a79105455f1 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -848,6 +848,13 @@ static bool __init sgx_page_cache_init(void)
>  		return false;
>  	}
> =20
> +	for_each_online_node(nid) {
> +		if (!node_isset(nid, sgx_numa_mask) &&
> +		    node_state(nid, N_MEMORY) && node_state(nid, N_CPU))
> +			pr_info("node%d has both CPUs and memory but doesn't have an EPC sect=
ion\n",
> +				nid);

Is this enough, or is there anything that would need to be done
automatically if this happens? With a tracepoint you could react to such
even but I'm totally fine with this.

> +	}
> +
>  	return true;
>  }
> =20

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
