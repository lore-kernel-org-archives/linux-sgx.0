Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62925C433EF
	for <linux-sgx@archiver.kernel.org>; Sun,  3 Apr 2022 08:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbiDCIO2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 3 Apr 2022 04:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbiDCIO1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 3 Apr 2022 04:14:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5473A1BB
        for <linux-sgx@vger.kernel.org>; Sun,  3 Apr 2022 01:12:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41C52B80AC3
        for <linux-sgx@vger.kernel.org>; Sun,  3 Apr 2022 08:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8500EC340F3;
        Sun,  3 Apr 2022 08:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648973552;
        bh=zv9YUykzXmNAUWrCUZ1/UYTWPBkY08YrqSGZDUZWzDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gR48ZC1+ZMEOve994KGnDNFy5LtJaHweT/8OzZzZQlcA+mqCV6B7Pww7JCI9674FY
         ev4hx4+3wpTYVpHPFCTFr2kirW/hwhlutGqYpfBKvh1xfpWNAzNoTWHHcyxY6A7Whx
         TuECnaenBwg+nzeZmMg6PCgq2CTQf8ce+UD/G75utr0YDBeTNWZanGgtWwec6Gwhgw
         z4puMHYvZ8P9tSEGaGGUiikaAbJSZQ2wspycL5UADaCNdBQj6LPeeFFnEQUMXSO4pP
         Zpctm0dPkq45OY3Wx/NGHQX4VFrNhAV4sK/J2/7dXcxLj/5ZK82b9Zlb24/lylPk/u
         GQJ2TL9y9egGA==
Date:   Sun, 3 Apr 2022 11:13:41 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Cathy Zhang <cathy.zhang@intel.com>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org,
        reinette.chatre@intel.com, dave.hansen@intel.com,
        ashok.raj@intel.com
Subject: Re: [RFC PATCH v3 01/10] x86/sgx: Introduce mechanism to prevent new
 initializations of EPC pages
Message-ID: <YklXNQfcaOcZE7GI@kernel.org>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
 <20220401142409.26215-2-cathy.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401142409.26215-2-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 01, 2022 at 10:24:00PM +0800, Cathy Zhang wrote:
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index b3c2e8d58142..00668e50848d 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -147,6 +147,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
>  static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
>  {
>  	struct sgx_enclave_create create_arg;
> +	int srcu_idx;
>  	void *secs;
>  	int ret;
>  
> @@ -162,9 +163,20 @@ static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
>  
>  	if (copy_from_user(secs, (void __user *)create_arg.src, PAGE_SIZE))
>  		ret = -EFAULT;
> -	else
> +	else {
> +		srcu_idx = srcu_read_lock(&sgx_lock_epc_srcu);
> +		if (sgx_epc_is_locked()) {
> +			srcu_read_unlock(&sgx_lock_epc_srcu, srcu_idx);
> +			ret = -EBUSY;
> +			goto out;
> +		}
> +
>  		ret = sgx_encl_create(encl, secs);
>  
> +		srcu_read_unlock(&sgx_lock_epc_srcu, srcu_idx);
> +	}
> +
> +out:

Nit: I'd rename this as 'err:'. 

>  	kfree(secs);
>  	return ret;
>  }

Please, take advantage of the label you created anyway:

  	if (copy_from_user(secs, (void __user *)create_arg.src, PAGE_SIZE {
  		ret = -EFAULT;
                goto out;
        }

Then fail cases have the exact same rollback procedure, and the code is
easier to read because it is less nested.

BR, Jarkko
 
