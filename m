Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 850C7EB64DD
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Aug 2023 05:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbjHKFkI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Aug 2023 01:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbjHKFkH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 11 Aug 2023 01:40:07 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DCA10C7
        for <linux-sgx@vger.kernel.org>; Thu, 10 Aug 2023 22:40:07 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-5222c5d71b8so2054386a12.2
        for <linux-sgx@vger.kernel.org>; Thu, 10 Aug 2023 22:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1691732405; x=1692337205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5B5FFkbErX2NpoKSzYxFkqYO7krwRKn/fOp2mY/XrTo=;
        b=cExTpeJvUd9TKVmz8/m9vdM+IEneB2FUqa4AHgp0uxeyFlOGQvbItMYwKZfNe/k/y/
         sQ95o2XON94sIsOTp1ASvtOCew70Jtwl7rXIt0HhR/QfFdNShPFjtMVJeV0ghGn0+8x7
         tpRy3G7ThoUjArHlJtvWnXc/VwIKxs7Mm3g9EOqk/XKqqVco2Rz7OPkI1Bu4rsSlRiCS
         1i9QpmdfTqQhkeqV9/9GPqtYvqBc/Yq9wkJSLkLgk0pCoc2lBdZ7HIA11rGJMqyVMkpM
         MKWBIAUzWKp+BHS/ocdR5uGP/ZpB9bBWoukzE2uagxSElxQydyKM0/3tvlOxHwPr/bwP
         VzOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691732405; x=1692337205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5B5FFkbErX2NpoKSzYxFkqYO7krwRKn/fOp2mY/XrTo=;
        b=OgM9NgHKsVNesiwQmJXMn0JppM5jdtQeKGbLSmVrdw1GiSx7WRVO/Yst/gYWWhC4DJ
         ZgflycGTxiLWUgdpABP4NU55ba6TA/NfBXtNLqtShPMpgCzgmq7giB2czlA7bJHtwlTB
         m/jIckJbjOdwYXASC6BlCYMRw+IkcqBK5ONbXWNw/qsCsEiMO02PWEjo9vAkyfrsGSC5
         MEFJQdqIesTlDPtjyIWqpRAXNZmRJrVq8sHep/tc3sV0PjUuw6NoVRxAHtApazpwbcrO
         wYUTzEdYNizpmTjRJZYf8DH1En6InQagJ8k3ms3tF18oU0XHMYEC/WhDePDWZZuhl8nV
         z11g==
X-Gm-Message-State: AOJu0YwXerQ1VlGf0sL/XUBFbd6enVbL9hnNBIWmGyTIbyKc4oVztM7p
        5FM4yC+2Yz77K8ypwnxl6dajGP7se2VPbDlJDmpYuaozE9s7SF8v
X-Google-Smtp-Source: AGHT+IFnuanE4UsihoJoxDg1R2wNpyxcxc+ZoUIg6iDDg8nvAI3bj36F5QLDu/n3XPnsHHrSH1udd6JdTI+bZ7Bst2Y=
X-Received: by 2002:a05:6402:31f0:b0:523:2816:773b with SMTP id
 dy16-20020a05640231f000b005232816773bmr841625edb.20.1691732405572; Thu, 10
 Aug 2023 22:40:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAMGffEnsLdn3BWOusgYwx7pA4ezS52B+JaDpyzh8+zatfeLzZw@mail.gmail.com>
 <op.19g4zze0wjvjmi@hhuan26-mobl.amr.corp.intel.com> <CUP7JLU4JBMW.31J7Y0TRJLV92@suppilovahvero>
In-Reply-To: <CUP7JLU4JBMW.31J7Y0TRJLV92@suppilovahvero>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Fri, 11 Aug 2023 07:39:54 +0200
Message-ID: <CAMGffEnBcbcjvC9iEf6YOhjmd4GezBCzLf81k0rZT2+_fjoxzg@mail.gmail.com>
Subject: Re: softlockup regarding sgx sgx_vepc_free_page+0x2e
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko, hi Haitao,

On Fri, Aug 11, 2023 at 12:11=E2=80=AFAM Jarkko Sakkinen <jarkko@kernel.org=
> wrote:
>
> On Thu Aug 10, 2023 at 9:44 PM EEST, Haitao Huang wrote:
> > On Thu, 10 Aug 2023 09:41:29 -0500, Jinpu Wang <jinpu.wang@ionos.com>
> > wrote:
> >
> > > Hi folks on the list,
> > >
> > > We hit following softlockup during test SGX VM with 5.15.125 kernel o=
n
> > > Icelake server:
> > >
> > > [  969.410230] CPU: 64 PID: 35093 Comm: qemu-7.1 Kdump: loaded
> > > Tainted: G        W  O L    5.15.125-pserver
> > > #5.15.125-1+feature+linux+5.15.y+20230809.0556+bda73c35~deb11 [
> > > 969.410233] Hardware name: Dell Inc. PowerEdge R650/0PYXKY, BIOS 1.9.=
2
> > > 11/17/2022 [  969.410234] RIP: 0010:sgx_vepc_free_page+0x2e/0x80 [
> > > 969.410242] Code: 00 41 54 8b 07 48 89 f9 48 c1 e0 05 48 2b 88 b0 a1
> > > 45 a0 48 c1 e9 05 48 c1 e1 0c 48 03 88 a8 a1 45 a0 b8 03 00 00 00 0f
> > > 01 cf <41> 89 c4 85 c0 74 0f 83 f8 0d 75 19 44 89 e0 41 5c c3 cc cc c=
c
> > > cc [  969.410244] RSP: 0018:ff6646e08ce77e20 EFLAGS: 00000202 [
> > > 969.410247] RAX: 0000000000000000 RBX: 000000000008001f RCX:
> > > ff6646f9f0ee6000 [  969.410248] RDX: 000000000000003d RSI:
> > > ff338d6614c00b68 RDI: ff6646f0d930fcc0 [  969.410249] RBP:
> > > ff338d6563367700 R08: ff6646f0d930fcc0 R09: ffffffffffffffff [
> > > 969.410250] R10: 0000000002000000 R11: ff338d65c29f9f10 R12:
> > > ff6646e08ce77e38 [  969.410252] R13: ff338d65891848e0 R14:
> > > ff338d64884a9c80 R15: 0000000000000000 [  969.410253] FS:
> > > 0000000000000000(0000) GS:ff338da3ff600000(0000)
> > > knlGS:0000000000000000 [  969.410255] CS:  0010 DS: 0000 ES: 0000 CR0=
:
> > > 0000000080050033 [  969.410256] CR2: 00007f23a0002806 CR3:
> > > 00000024ce60a006 CR4: 0000000000773ee0 [  969.410257] DR0:
> > > 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 [
> > > 969.410258] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > > 0000000000000400 [  969.410260] PKRU: 55555554 [  969.410260] Call
> > > Trace: [  969.410262]  <IRQ> [  969.410264]  ?
> > > watchdog_timer_fn+0x1b4/0x210 [  969.410269]  ?
> > > lockup_detector_update_enable+0x50/0x50 [  969.410272]  ?
> > > __hrtimer_run_queues+0x127/0x280 [  969.410276]  ?
> > > hrtimer_interrupt+0xfc/0x210 [  969.410279]  ?
> > > __sysvec_apic_timer_interrupt+0x59/0xd0 [  969.410281]  ?
> > > sysvec_apic_timer_interrupt+0x6d/0x90 [  969.410285]  </IRQ> [
> > > 969.410286]  <TASK> [  969.410287]  ?
> > > asm_sysvec_apic_timer_interrupt+0x16/0x20 [  969.410291]  ?
> > > sgx_vepc_free_page+0x2e/0x80 [  969.410293]
> > > sgx_vepc_release+0x65/0x220 [  969.410296]  __fput+0x89/0x250 [
> > > 969.410301]  task_work_run+0x59/0x90 [  969.410306]
> > > do_exit+0x337/0x9a0 [  969.410309]  ? do_user_addr_fault+0x1cd/0x660 =
[
> > >  969.410312]  __x64_sys_exit+0x17/0x20 [  969.410314]
> > > do_syscall_64+0x38/0x90 [  969.410317]
> > > entry_SYSCALL_64_after_hwframe+0x67/0xd1 [  969.410319] RIP:
> > > 0033:0x7f23afe93f56 [  969.410322] Code: Unable to access opcode byte=
s
> > > at RIP 0x7f23afe93f2c. [  969.410323] RSP: 002b:00007f23a5dd6800
> > > EFLAGS: 00000246 ORIG_RAX: 000000000000003c [  969.410325] RAX:
> > > ffffffffffffffda RBX: 00007f23a5dd7700 RCX: 00007f23afe93f56 [
> > > 969.410326] RDX: 000000000000003c RSI: 00000000007fb000 RDI:
> > > 0000000000000000 [  969.410327] RBP: 00007f23a55d7000 R08:
> > > 00007f23a5dd66b0 R09: 00007f23a5dd6630 [  969.410328] R10:
> > > 0000000000000008 R11: 0000000000000246 R12: 00007ffe693cbeee [
> > > 969.410329] R13: 00007ffe693cbeef R14: 00007f23a5dd68c0 R15:
> > > 0000000000802000 [  969.410331]  </TASK>
> > >
> > > is it known?
> > >
> > > I guess something like this is needed?
> > > diff --git a/arch/x86/kernel/cpu/sgx/virt.c
> > > b/arch/x86/kernel/cpu/sgx/virt.c index 6a77a14eee38..9f863250f08d
> > > 100644 --- a/arch/x86/kernel/cpu/sgx/virt.c +++
> > > b/arch/x86/kernel/cpu/sgx/virt.c @@ -204,6 +204,7 @@ static int
> > > sgx_vepc_release(struct inode *inode, struct file *file)
> > >           continue;                   xa_erase(&vepc->page_array,
> > > index); +               cond_resched();         }           /* @@
> > > -222,6 +223,7 @@ static int sgx_vepc_release(struct inode *inode,
> > > struct file *file)
> > > list_add_tail(&epc_page->list, &secs_pages);
> > > xa_erase(&vepc->page_array, index); +               cond_resched();
> > >      }           /*
> >
> > Thanks for reporting. This seems reasonable change. Did you test with t=
he
> > change
> >
> > Could you submit a patch for review? Or I can do it if you prefer and l=
et
> > me know the host EPC and VM EPC configuration info for repro.
>
> +1
>
> BR, Jarkko
Thanks for the reply, I will resubmit a formal patch for review.


Thx!
