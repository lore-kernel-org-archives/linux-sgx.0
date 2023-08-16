Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82207C25B4F
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Aug 2023 20:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbjHPUeV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Aug 2023 16:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346221AbjHPUeN (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 16 Aug 2023 16:34:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6636E2701
        for <linux-sgx@vger.kernel.org>; Wed, 16 Aug 2023 13:34:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 049566629A
        for <linux-sgx@vger.kernel.org>; Wed, 16 Aug 2023 20:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DB0C433C7;
        Wed, 16 Aug 2023 20:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692218051;
        bh=DwzwM5MhwhAhJQWqibnaMMFpTz2RmTQ4zcmHcowPGbI=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=AqtiorNe2K+R/QoAaWueJ8Fu1ZQ6v2RAICPuBIhIXwK+b22Wp7qZxnGO8tLRguAG7
         HSVBV5/idwfRtiF4XsvUR6txVUCZQgMhhhUztO08PX2QBR8V7vPpH8Or4PEyDLlCvD
         huFUG44Z6VdCE01aPuUeo3zJgSOSmGDiJnrB4bxBPbow+sgTOhEqUObW4hLyEvEs/F
         2Ge03SED13oUHptwlCvBChV9vfXuHqTKTKC14fMBuPgHc+jRvMQC3U/rZRSPLqRWbp
         Y5VsjtDx5ZOjzrCeweD1EdFJQ8zlTee29wf3copKP7TVtsfTK8euejcpTNKWML/vfT
         5v9JyAy0ciscg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 16 Aug 2023 23:34:08 +0300
Message-Id: <CUU98FETTOER.MLJEHF8QNJ6L@suppilovahvero>
Subject: Re: [PATCH] x86/sgx: Avoid softlockup from sgx_vepc_release
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     "Huang, Kai" <kai.huang@intel.com>,
        "jinpu.wang@ionos.com" <jinpu.wang@ionos.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "yu.zhang@ionos.com" <yu.zhang@ionos.com>,
        "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>
X-Mailer: aerc 0.14.0
References: <20230814043714.107971-1-jinpu.wang@ionos.com>
 <3954697abb1a6c84c4b30fbd0d5edcafae6f6966.camel@intel.com>
In-Reply-To: <3954697abb1a6c84c4b30fbd0d5edcafae6f6966.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue Aug 15, 2023 at 2:58 AM EEST, Huang, Kai wrote:
> On Mon, 2023-08-14 at 06:37 +0200, Jack Wang wrote:
> > We hit softlocup with following call trace:
> >  kernel: [ 2041.288210] Call Trace:
> > kernel: [ 2041.288213]  <IRQ>
> > kernel: [ 2041.288216]  ? watchdog_timer_fn+0x1b4/0x210
> > kernel: [ 2041.288222]  ? lockup_detector_update_enable+0x50/0x50
> > kernel: [ 2041.288225]  ? __hrtimer_run_queues+0x127/0x280
> > kernel: [ 2041.288230]  ? hrtimer_interrupt+0xfc/0x210
> > kernel: [ 2041.288233]  ? __sysvec_apic_timer_interrupt+0x59/0xd0
> > kernel: [ 2041.288237]  ? sysvec_apic_timer_interrupt+0x6d/0x90
> > kernel: [ 2041.288242]  </IRQ>
> > kernel: [ 2041.288242]  <TASK>
> > kernel: [ 2041.288244]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
> > kernel: [ 2041.288250]  xa_erase+0x21/0xb0
> > kernel: [ 2041.288256]  ? sgx_free_epc_page+0x20/0x50
> > kernel: [ 2041.288260]  sgx_vepc_release+0x75/0x220
> > kernel: [ 2041.288263]  __fput+0x89/0x250
> > kernel: [ 2041.288269]  task_work_run+0x59/0x90
> > kernel: [ 2041.288275]  do_exit+0x337/0x9a0
> >=20
> > Similar like 8795359e35bc ("x86/sgx: Silence softlockup detection when =
releasing large enclaves")
> > The test system has 64GB of enclave memory, and all assigned to a singl=
e
> > VM. Release vepc take longer time and triggers the softlockup warning.
> >=20
> > Add a cond_resched() to give other tasks a chance to run and placate
> > the softlockup detector.
> >=20
> > Cc: Jarkko Sakkinen <jarkko@kernel.org>
> > Cc: Haitao Huang <haitao.huang@linux.intel.com>
> > Reported-by: Yu Zhang <yu.zhang@ionos.com>
> >=20
> > Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/virt.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >=20
> > diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/v=
irt.c
> > index c3e37eaec8ec..01d2795792cc 100644
> > --- a/arch/x86/kernel/cpu/sgx/virt.c
> > +++ b/arch/x86/kernel/cpu/sgx/virt.c
> > @@ -204,6 +204,7 @@ static int sgx_vepc_release(struct inode *inode, st=
ruct file *file)
> >  			continue;
> > =20
> >  		xa_erase(&vepc->page_array, index);
> > +		cond_resched();
> >  	}
> > =20
> >  	/*
> > @@ -222,6 +223,7 @@ static int sgx_vepc_release(struct inode *inode, st=
ruct file *file)
> >  			list_add_tail(&epc_page->list, &secs_pages);
> > =20
> >  		xa_erase(&vepc->page_array, index);
> > +		cond_resched();
> >  	}
> > =20
> >  	/*
>
> This adds cond_resched() to the first two loops: releasing non-SECS pages=
 and
> releasing SECS pages which don't have children on remote vepc instance(s)=
.=20
> There is a third round loop to release SECS pages which have children on =
remote
> vepc instance(s).  I think it's better to add cond_resched() there too, a=
lthough
> it's extremely unlikely it could trigger softlockup w/o cond_resched().
>
> Also similar to 8795359e35bc ("x86/sgx: Silence softlockup detection when
> releasing large enclaves"), this looks stable-kernel material.  So perhap=
s add:
>
> Cc: stable@vger.kernel.org

+ would not hurt to have also fixes tag for clarity.

BR, Jarkko

