Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE51C433EF
	for <linux-sgx@archiver.kernel.org>; Wed, 11 May 2022 10:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbiEKKdX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 May 2022 06:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiEKKdW (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 11 May 2022 06:33:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A91568335
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 03:33:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3BE7B81EC8
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 10:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2807BC340ED;
        Wed, 11 May 2022 10:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652265198;
        bh=z4fp2Fns+2JhVvI8y3Zw4MDSld1IL6taKfdu1/0C2gk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qk6m6ypFBhXNRdoLV5EVHzKc2PrHgKmQVdpH7S4yRE2USWJCf9PmIFP9vmW9P+vMM
         IE1s+TTCT8QY02bj4CiQyr6J1PMOHCDFZlMOGLn1hxNYJ6I9g0u3nbY+plMLy4fnog
         RgeGugJZ2fS0cXS8RM6pt87Bv5XILCWOJI8NPHl/r2NIgkxMG5/sTcLL3ffNTV2knw
         eWkYVjPHrKBiDMPT7xFhEbTq5+a+/QoxbMWU6BF3ejp1c8ESERgI/u0vggWALx7gSC
         KlVc4poF2n51cFfmOuDs4OgIIDBfN6HZ6lLL625YAA1O1lnNT9RhmYFCSyXNOJdoH6
         p6PZMEdoqQzrA==
Date:   Wed, 11 May 2022 13:31:48 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Zhiquan Li <zhiquan1.li@intel.com>
Cc:     linux-sgx@vger.kernel.org, tony.luck@intel.com,
        dave.hansen@linux.intel.com, seanjc@google.com, fan.du@intel.com
Subject: Re: [PATCH 1/4] x86/sgx: Move struct sgx_vepc definition to sgx.h
Message-ID: <YnuQlEAG6kEAbLY2@kernel.org>
References: <20220510031725.3181361-1-zhiquan1.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510031725.3181361-1-zhiquan1.li@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, May 10, 2022 at 11:17:25AM +0800, Zhiquan Li wrote:
> Move struct sgx_vepc definition to sgx.h so that it can be used outside
> of virt.c.
> 
> Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/sgx.h  | 5 +++++
>  arch/x86/kernel/cpu/sgx/virt.c | 5 -----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index 0f17def9fe6f..83ff8c3e81cf 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -101,4 +101,9 @@ static inline int __init sgx_vepc_init(void)
>  
>  void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
>  
> +struct sgx_vepc {
> +	struct xarray page_array;
> +	struct mutex lock;
> +};

Would not BTW hurt to add some documentation for this struct, while at it.
Nothing wrong with the code change itself but what about adding a brief
explanation what it is?

> +
>  #endif /* _X86_SGX_H */
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> index 6a77a14eee38..c9c8638b5dc4 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -18,11 +18,6 @@
>  #include "encls.h"
>  #include "sgx.h"
>  
> -struct sgx_vepc {
> -	struct xarray page_array;
> -	struct mutex lock;
> -};
> -
>  /*
>   * Temporary SECS pages that cannot be EREMOVE'd due to having child in other
>   * virtual EPC instances, and the lock to protect it.
> -- 
> 2.25.1
> 
