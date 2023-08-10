Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A345BC001B0
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Aug 2023 22:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjHJWL1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Aug 2023 18:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjHJWL1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 10 Aug 2023 18:11:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03D42719
        for <linux-sgx@vger.kernel.org>; Thu, 10 Aug 2023 15:11:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F32C65794
        for <linux-sgx@vger.kernel.org>; Thu, 10 Aug 2023 22:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1E3C433C7;
        Thu, 10 Aug 2023 22:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691705485;
        bh=WKp+2ACYW6USMp1HnJFMSUfBtZBreDThImZ/CYkuFPs=;
        h=Date:Subject:From:To:References:In-Reply-To:From;
        b=tQKIp1gkvCeiDOdbVQYzwqqLbuc2CFRrpH4Yw8uZK6fVSQwEhUctSB2heubc2Y8gm
         ZmzqVsAGAg7M5RMxcvhAEGODBqsVAO/qsEjVyCcYkTtvL2BBQXL2FwMByXgshbYBWF
         +nDcInwBBQSZGIkKZYJO9/Q/XJ4kukfXcN+qC3UMphAhQ3Fh96QeZZUwZP02xtwgeC
         bcai/E9SuodyRlwyBkYBT+c7bgJOUGQ2k0QlZn/TFapX5viBJPc7W7Ve8/Wi8Hnxen
         zZTTMMcHr07qSPQ17nWcpg+VtvORTDH9+DGLgbjn4e8HL60Nq9AazRujprx4HoZUCS
         uppnM1oubcHWw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 11 Aug 2023 01:11:22 +0300
Message-Id: <CUP7JLU4JBMW.31J7Y0TRJLV92@suppilovahvero>
Subject: Re: softlockup regarding sgx sgx_vepc_free_page+0x2e
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     "Haitao Huang" <haitao.huang@linux.intel.com>,
        <linux-sgx@vger.kernel.org>, "Jinpu Wang" <jinpu.wang@ionos.com>
X-Mailer: aerc 0.14.0
References: <CAMGffEnsLdn3BWOusgYwx7pA4ezS52B+JaDpyzh8+zatfeLzZw@mail.gmail.com> <op.19g4zze0wjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <op.19g4zze0wjvjmi@hhuan26-mobl.amr.corp.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu Aug 10, 2023 at 9:44 PM EEST, Haitao Huang wrote:
> On Thu, 10 Aug 2023 09:41:29 -0500, Jinpu Wang <jinpu.wang@ionos.com> =20
> wrote:
>
> > Hi folks on the list,
> >
> > We hit following softlockup during test SGX VM with 5.15.125 kernel on
> > Icelake server:
> >
> > [  969.410230] CPU: 64 PID: 35093 Comm: qemu-7.1 Kdump: loaded
> > Tainted: G        W  O L    5.15.125-pserver
> > #5.15.125-1+feature+linux+5.15.y+20230809.0556+bda73c35~deb11 [
> > 969.410233] Hardware name: Dell Inc. PowerEdge R650/0PYXKY, BIOS 1.9.2
> > 11/17/2022 [  969.410234] RIP: 0010:sgx_vepc_free_page+0x2e/0x80 [
> > 969.410242] Code: 00 41 54 8b 07 48 89 f9 48 c1 e0 05 48 2b 88 b0 a1
> > 45 a0 48 c1 e9 05 48 c1 e1 0c 48 03 88 a8 a1 45 a0 b8 03 00 00 00 0f
> > 01 cf <41> 89 c4 85 c0 74 0f 83 f8 0d 75 19 44 89 e0 41 5c c3 cc cc cc
> > cc [  969.410244] RSP: 0018:ff6646e08ce77e20 EFLAGS: 00000202 [
> > 969.410247] RAX: 0000000000000000 RBX: 000000000008001f RCX:
> > ff6646f9f0ee6000 [  969.410248] RDX: 000000000000003d RSI:
> > ff338d6614c00b68 RDI: ff6646f0d930fcc0 [  969.410249] RBP:
> > ff338d6563367700 R08: ff6646f0d930fcc0 R09: ffffffffffffffff [
> > 969.410250] R10: 0000000002000000 R11: ff338d65c29f9f10 R12:
> > ff6646e08ce77e38 [  969.410252] R13: ff338d65891848e0 R14:
> > ff338d64884a9c80 R15: 0000000000000000 [  969.410253] FS:
> > 0000000000000000(0000) GS:ff338da3ff600000(0000)
> > knlGS:0000000000000000 [  969.410255] CS:  0010 DS: 0000 ES: 0000 CR0:
> > 0000000080050033 [  969.410256] CR2: 00007f23a0002806 CR3:
> > 00000024ce60a006 CR4: 0000000000773ee0 [  969.410257] DR0:
> > 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 [
> > 969.410258] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > 0000000000000400 [  969.410260] PKRU: 55555554 [  969.410260] Call
> > Trace: [  969.410262]  <IRQ> [  969.410264]  ?
> > watchdog_timer_fn+0x1b4/0x210 [  969.410269]  ?
> > lockup_detector_update_enable+0x50/0x50 [  969.410272]  ?
> > __hrtimer_run_queues+0x127/0x280 [  969.410276]  ?
> > hrtimer_interrupt+0xfc/0x210 [  969.410279]  ?
> > __sysvec_apic_timer_interrupt+0x59/0xd0 [  969.410281]  ?
> > sysvec_apic_timer_interrupt+0x6d/0x90 [  969.410285]  </IRQ> [
> > 969.410286]  <TASK> [  969.410287]  ?
> > asm_sysvec_apic_timer_interrupt+0x16/0x20 [  969.410291]  ?
> > sgx_vepc_free_page+0x2e/0x80 [  969.410293]
> > sgx_vepc_release+0x65/0x220 [  969.410296]  __fput+0x89/0x250 [
> > 969.410301]  task_work_run+0x59/0x90 [  969.410306]
> > do_exit+0x337/0x9a0 [  969.410309]  ? do_user_addr_fault+0x1cd/0x660 [
> >  969.410312]  __x64_sys_exit+0x17/0x20 [  969.410314]
> > do_syscall_64+0x38/0x90 [  969.410317]
> > entry_SYSCALL_64_after_hwframe+0x67/0xd1 [  969.410319] RIP:
> > 0033:0x7f23afe93f56 [  969.410322] Code: Unable to access opcode bytes
> > at RIP 0x7f23afe93f2c. [  969.410323] RSP: 002b:00007f23a5dd6800
> > EFLAGS: 00000246 ORIG_RAX: 000000000000003c [  969.410325] RAX:
> > ffffffffffffffda RBX: 00007f23a5dd7700 RCX: 00007f23afe93f56 [
> > 969.410326] RDX: 000000000000003c RSI: 00000000007fb000 RDI:
> > 0000000000000000 [  969.410327] RBP: 00007f23a55d7000 R08:
> > 00007f23a5dd66b0 R09: 00007f23a5dd6630 [  969.410328] R10:
> > 0000000000000008 R11: 0000000000000246 R12: 00007ffe693cbeee [
> > 969.410329] R13: 00007ffe693cbeef R14: 00007f23a5dd68c0 R15:
> > 0000000000802000 [  969.410331]  </TASK>
> >
> > is it known?
> >
> > I guess something like this is needed?
> > diff --git a/arch/x86/kernel/cpu/sgx/virt.c
> > b/arch/x86/kernel/cpu/sgx/virt.c index 6a77a14eee38..9f863250f08d
> > 100644 --- a/arch/x86/kernel/cpu/sgx/virt.c +++
> > b/arch/x86/kernel/cpu/sgx/virt.c @@ -204,6 +204,7 @@ static int
> > sgx_vepc_release(struct inode *inode, struct file *file)
> >           continue;                   xa_erase(&vepc->page_array,
> > index); +               cond_resched();         }           /* @@
> > -222,6 +223,7 @@ static int sgx_vepc_release(struct inode *inode,
> > struct file *file)
> > list_add_tail(&epc_page->list, &secs_pages);
> > xa_erase(&vepc->page_array, index); +               cond_resched();
> >      }           /*
>
> Thanks for reporting. This seems reasonable change. Did you test with the=
 =20
> change
>
> Could you submit a patch for review? Or I can do it if you prefer and let=
 =20
> me know the host EPC and VM EPC configuration info for repro.

+1

BR, Jarkko
