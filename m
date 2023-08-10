Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9010C001E0
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Aug 2023 14:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbjHJOmI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Aug 2023 10:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbjHJOlt (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 10 Aug 2023 10:41:49 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB9926BC
        for <linux-sgx@vger.kernel.org>; Thu, 10 Aug 2023 07:41:42 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-307d20548adso938473f8f.0
        for <linux-sgx@vger.kernel.org>; Thu, 10 Aug 2023 07:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1691678500; x=1692283300;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jiAjzJOsyKqc9NWulv8iUKiZTFWW51jELYFWDIcxjcA=;
        b=OhH/9Nly/49RE2gPHoi0jsxXvApXjs4BJ0ke7nJ9uLTsrbbz4TwY2a6Sl8P+eG6xYr
         V5G37GcOC7Wo2IoWVHO/HvHaNgD0bqqXOdeE2yRNIwGZVX7/sJOvgc4LJEvJWM1GEp3m
         QhZZLsWx/8TpA/VldxEz6Vz7L1KxwnNLVEwYkJpyn/ZEl9COyAAtn0IzbpMCJ3pJSbzW
         +6AjeeTSjTS5k0Y5XOZSJpgt4+uEvwUcsAhn5x/Lmpn9QFVY8r6zkqnowwxhdxhycZ9F
         I9C/9GuvT8nhe6magFubCMCpqe2u3UJXJvpXxM2MUpP9uO9CQ45jN+eDYF16ByXBwt56
         J9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691678500; x=1692283300;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jiAjzJOsyKqc9NWulv8iUKiZTFWW51jELYFWDIcxjcA=;
        b=LO+Po6Nr2g7+5iC0m/beH21D4FwYKgLYxirXbNLz6Co/jMooDBCg0f+i4uUWWK8WwD
         +k4w/5o9gC+8XapnCZ+SM3ELjdAtCVYnlclvy626J5xcZGe5hM/amJtRGwZRHL2PGYo6
         Xi01SP0Nq2q3+IzxkT3g5BFI0esp2iTNxrAInDjtbH8q/nSvB+PjZDhFrWva+nNC5jgL
         JEOzu+AMFJAXZ39wrAj0gn7dPkwUq7/ZPaym+yXSBWGxe5JlOnQAfHJU4xsTnxfCRMth
         RY/e1rAyFYTd9BLcEh6oWnm58Buq6OChG1PmSBEbrXriOHXHpZoAdgcgHEzLq8cAsm22
         H0rA==
X-Gm-Message-State: AOJu0YyAzuhFpnqZpVLxJbd8qVjEOJcIL9bUTIk9RfpDhgNwBz0t8dQG
        xQLCeDCsFOVWgxq5NCcNg7/fzSvzTfWAI+wvioZ/0pVZGVVroXgK7OI=
X-Google-Smtp-Source: AGHT+IFJQaQB8NnD/IWQXzL+5a+hVaZXNMVSCGCO7JXkqC/tre8FOJaMDMvf+KqiuUzz3I/MmUG5YkJAuwWStOkvvRI=
X-Received: by 2002:a5d:4a8f:0:b0:306:46c4:d313 with SMTP id
 o15-20020a5d4a8f000000b0030646c4d313mr2453824wrq.28.1691678500357; Thu, 10
 Aug 2023 07:41:40 -0700 (PDT)
MIME-Version: 1.0
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 10 Aug 2023 16:41:29 +0200
Message-ID: <CAMGffEnsLdn3BWOusgYwx7pA4ezS52B+JaDpyzh8+zatfeLzZw@mail.gmail.com>
Subject: softlockup regarding sgx sgx_vepc_free_page+0x2e
To:     linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi folks on the list,

We hit following softlockup during test SGX VM with 5.15.125 kernel on
Icelake server:

[  969.410230] CPU: 64 PID: 35093 Comm: qemu-7.1 Kdump: loaded
Tainted: G        W  O L    5.15.125-pserver
#5.15.125-1+feature+linux+5.15.y+20230809.0556+bda73c35~deb11 [
969.410233] Hardware name: Dell Inc. PowerEdge R650/0PYXKY, BIOS 1.9.2
11/17/2022 [  969.410234] RIP: 0010:sgx_vepc_free_page+0x2e/0x80 [
969.410242] Code: 00 41 54 8b 07 48 89 f9 48 c1 e0 05 48 2b 88 b0 a1
45 a0 48 c1 e9 05 48 c1 e1 0c 48 03 88 a8 a1 45 a0 b8 03 00 00 00 0f
01 cf <41> 89 c4 85 c0 74 0f 83 f8 0d 75 19 44 89 e0 41 5c c3 cc cc cc
cc [  969.410244] RSP: 0018:ff6646e08ce77e20 EFLAGS: 00000202 [
969.410247] RAX: 0000000000000000 RBX: 000000000008001f RCX:
ff6646f9f0ee6000 [  969.410248] RDX: 000000000000003d RSI:
ff338d6614c00b68 RDI: ff6646f0d930fcc0 [  969.410249] RBP:
ff338d6563367700 R08: ff6646f0d930fcc0 R09: ffffffffffffffff [
969.410250] R10: 0000000002000000 R11: ff338d65c29f9f10 R12:
ff6646e08ce77e38 [  969.410252] R13: ff338d65891848e0 R14:
ff338d64884a9c80 R15: 0000000000000000 [  969.410253] FS:
0000000000000000(0000) GS:ff338da3ff600000(0000)
knlGS:0000000000000000 [  969.410255] CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033 [  969.410256] CR2: 00007f23a0002806 CR3:
00000024ce60a006 CR4: 0000000000773ee0 [  969.410257] DR0:
0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 [
969.410258] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400 [  969.410260] PKRU: 55555554 [  969.410260] Call
Trace: [  969.410262]  <IRQ> [  969.410264]  ?
watchdog_timer_fn+0x1b4/0x210 [  969.410269]  ?
lockup_detector_update_enable+0x50/0x50 [  969.410272]  ?
__hrtimer_run_queues+0x127/0x280 [  969.410276]  ?
hrtimer_interrupt+0xfc/0x210 [  969.410279]  ?
__sysvec_apic_timer_interrupt+0x59/0xd0 [  969.410281]  ?
sysvec_apic_timer_interrupt+0x6d/0x90 [  969.410285]  </IRQ> [
969.410286]  <TASK> [  969.410287]  ?
asm_sysvec_apic_timer_interrupt+0x16/0x20 [  969.410291]  ?
sgx_vepc_free_page+0x2e/0x80 [  969.410293]
sgx_vepc_release+0x65/0x220 [  969.410296]  __fput+0x89/0x250 [
969.410301]  task_work_run+0x59/0x90 [  969.410306]
do_exit+0x337/0x9a0 [  969.410309]  ? do_user_addr_fault+0x1cd/0x660 [
 969.410312]  __x64_sys_exit+0x17/0x20 [  969.410314]
do_syscall_64+0x38/0x90 [  969.410317]
entry_SYSCALL_64_after_hwframe+0x67/0xd1 [  969.410319] RIP:
0033:0x7f23afe93f56 [  969.410322] Code: Unable to access opcode bytes
at RIP 0x7f23afe93f2c. [  969.410323] RSP: 002b:00007f23a5dd6800
EFLAGS: 00000246 ORIG_RAX: 000000000000003c [  969.410325] RAX:
ffffffffffffffda RBX: 00007f23a5dd7700 RCX: 00007f23afe93f56 [
969.410326] RDX: 000000000000003c RSI: 00000000007fb000 RDI:
0000000000000000 [  969.410327] RBP: 00007f23a55d7000 R08:
00007f23a5dd66b0 R09: 00007f23a5dd6630 [  969.410328] R10:
0000000000000008 R11: 0000000000000246 R12: 00007ffe693cbeee [
969.410329] R13: 00007ffe693cbeef R14: 00007f23a5dd68c0 R15:
0000000000802000 [  969.410331]  </TASK>

is it known?

I guess something like this is needed?
diff --git a/arch/x86/kernel/cpu/sgx/virt.c
b/arch/x86/kernel/cpu/sgx/virt.c index 6a77a14eee38..9f863250f08d
100644 --- a/arch/x86/kernel/cpu/sgx/virt.c +++
b/arch/x86/kernel/cpu/sgx/virt.c @@ -204,6 +204,7 @@ static int
sgx_vepc_release(struct inode *inode, struct file *file)
          continue;                   xa_erase(&vepc->page_array,
index); +               cond_resched();         }           /* @@
-222,6 +223,7 @@ static int sgx_vepc_release(struct inode *inode,
struct file *file)
list_add_tail(&epc_page->list, &secs_pages);
xa_erase(&vepc->page_array, index); +               cond_resched();
     }           /*

QEMU commandline:
qemu-7.1 -name Serverwittchen46bd476e-a1f1-475e-8e65-4ef2c44f63f7 -m
4096,slots=3D252,maxmem=3D256G -M pc-i440fx-7.0 -enable-kvm
-no-user-config -nodefaults -rtc base=3Dutc -device pvpanic -object
rng-random,filename=3D/dev/urandom,id=3Drng0 -device
virtio-rng-pci,rng=3Drng0,max-bytes=3D1024,period=3D1000,bus=3Dpci.0,addr=
=3D0x3
-netdev tap,ifname=3Dn020166658e84,id=3Dhostnet6,vhost=3Don,vhostforce=3Don=
,vnet_hdr=3Don,script=3Dno,downscript=3Dno
-device virtio-net-pci,netdev=3Dhostnet6,id=3Dnet6,mac=3D02:01:66:65:8e:84,=
bus=3Dpci.0,addr=3D0x6
-chardev pty,id=3Dcharserial0 -device
isa-serial,chardev=3Dcharserial0,id=3Dserial0 -usb -device
usb-tablet,id=3Dinput0 -vnc 0.0.0.0:122 -vga qxl -cpu
Icelake-Server-v6,+vmx,+sgx,+sgx1,+sgx2,+sgx-kss,+sgxlc,+sgx-exinfo,+sgx-de=
bug,+sgx-mode64,+sgx-provisionkey,+sgx-tokenkey,enforce,+hv-relaxed,+hv-vap=
ic,+hv-time,+hv-runtime,hv-spinlocks=3D0x1fff,+hv-vpindex,+hv-synic,+hv-sti=
mer,+hv-tlbflush,hv-no-nonarch-coresharing=3Don,hv-ipi
-smp 4 -object iothread,id=3Diothread5 -drive
file=3D/dev/md0,if=3Dnone,id=3Ddrive-virtio-disk5,format=3Draw,snapshot=3Do=
ff,node-name=3Dnode-virtio-disk5,aio=3Dnative,discard=3Doff,cache=3Dnone
-device virtio-blk-pci,serial=3Deaaddb33707b7b1d,bus=3Dpci.0,addr=3D0x5,dri=
ve=3Ddrive-virtio-disk5,iothread=3Diothread5,num-queues=3D2,discard=3Doff,i=
d=3Dvirtio-disk5,bootindex=3D1
-S -msg timestamp=3Don -object
memory-backend-epc,id=3Dmem1,size=3D65536M,prealloc=3Don -M
sgx-epc.0.memdev=3Dmem1,sgx-epc.0.node=3D0 -qmp
unix:/opt/profitbricks/vcb/pbkvm/mon/46bd476e-a1f1-475e-8e65-4ef2c44f63f7.s=
ock,server,nowait
-qmp unix:/opt/profitbricks/vcb/pbkvm/metrics/46bd476e-a1f1-475e-8e65-4ef2c=
44f63f7.sock,server,nowait
-uuid 46bd476e-a1f1-475e-8e65-4ef2c44f63f7

Regards!
Jinpu Wang
