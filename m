Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 386C5EB64DD
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Aug 2023 17:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbjHNRg1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Aug 2023 13:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjHNRf7 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 14 Aug 2023 13:35:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F3010D0
        for <linux-sgx@vger.kernel.org>; Mon, 14 Aug 2023 10:35:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F223C635AA
        for <linux-sgx@vger.kernel.org>; Mon, 14 Aug 2023 17:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EECCC433C8;
        Mon, 14 Aug 2023 17:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692034557;
        bh=tHYPsHzJPyhLdeuzy9XtKbhgfCY7CXyAmOKQYEQJvNo=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=qepWPg70IedTFzTk+Gvt3VFvU+Pm+LojO0WHfQJ6hAZVTU4KM7L9IflWERLnsSs/T
         waEQXf3YmCYVpjqCWXAHztKoXEKcXTbaN72VDPbLDt4x+4djzEgUzhDPVxMV49AHyz
         L9BAjyw3Hc6N2BZuq839vr9VPQ28uZM9sDFnCfAVRMsUAVsxR4XkgP+TJQOBUVIBRU
         k1CvogrvFXd9AEP7FWUe7WID6HIS2uIEnF1Im4JLtv0j51APC0Qg43VbTy98E1aYwr
         a7X0cqbC0UG2l/GwEOYcYhgHI66EKq1xGtbBG1xzvksjE+gw8bwKa8kF2od4FZCBQX
         gS2Y0muNZd+EA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 14 Aug 2023 20:35:54 +0300
Message-Id: <CUSG6VFCH0VN.1GBI3C0H1VU4Q@suppilovahvero>
Cc:     <linux-sgx@vger.kernel.org>,
        "Haitao Huang" <haitao.huang@linux.intel.com>,
        "Yu Zhang" <yu.zhang@ionos.com>
Subject: Re: [PATCH] x86/sgx: Avoid softlockup from sgx_vepc_release
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     "Jack Wang" <jinpu.wang@ionos.com>
X-Mailer: aerc 0.14.0
References: <20230814043714.107971-1-jinpu.wang@ionos.com>
In-Reply-To: <20230814043714.107971-1-jinpu.wang@ionos.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon Aug 14, 2023 at 7:37 AM EEST, Jack Wang wrote:
> We hit softlocup with following call trace:
>  kernel: [ 2041.288210] Call Trace:
> kernel: [ 2041.288213]  <IRQ>
> kernel: [ 2041.288216]  ? watchdog_timer_fn+0x1b4/0x210
> kernel: [ 2041.288222]  ? lockup_detector_update_enable+0x50/0x50
> kernel: [ 2041.288225]  ? __hrtimer_run_queues+0x127/0x280
> kernel: [ 2041.288230]  ? hrtimer_interrupt+0xfc/0x210
> kernel: [ 2041.288233]  ? __sysvec_apic_timer_interrupt+0x59/0xd0
> kernel: [ 2041.288237]  ? sysvec_apic_timer_interrupt+0x6d/0x90
> kernel: [ 2041.288242]  </IRQ>
> kernel: [ 2041.288242]  <TASK>
> kernel: [ 2041.288244]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
> kernel: [ 2041.288250]  xa_erase+0x21/0xb0
> kernel: [ 2041.288256]  ? sgx_free_epc_page+0x20/0x50
> kernel: [ 2041.288260]  sgx_vepc_release+0x75/0x220
> kernel: [ 2041.288263]  __fput+0x89/0x250
> kernel: [ 2041.288269]  task_work_run+0x59/0x90
> kernel: [ 2041.288275]  do_exit+0x337/0x9a0
>
> Similar like 8795359e35bc ("x86/sgx: Silence softlockup detection when re=
leasing large enclaves")
> The test system has 64GB of enclave memory, and all assigned to a single
> VM. Release vepc take longer time and triggers the softlockup warning.
>
> Add a cond_resched() to give other tasks a chance to run and placate
> the softlockup detector.
>
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Haitao Huang <haitao.huang@linux.intel.com>
> Reported-by: Yu Zhang <yu.zhang@ionos.com>
>
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  arch/x86/kernel/cpu/sgx/virt.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/vir=
t.c
> index c3e37eaec8ec..01d2795792cc 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -204,6 +204,7 @@ static int sgx_vepc_release(struct inode *inode, stru=
ct file *file)
>  			continue;
> =20
>  		xa_erase(&vepc->page_array, index);
> +		cond_resched();
>  	}
> =20
>  	/*
> @@ -222,6 +223,7 @@ static int sgx_vepc_release(struct inode *inode, stru=
ct file *file)
>  			list_add_tail(&epc_page->list, &secs_pages);
> =20
>  		xa_erase(&vepc->page_array, index);
> +		cond_resched();
>  	}
> =20
>  	/*
> --=20
> 2.34.1

Thank you for looking into this.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
