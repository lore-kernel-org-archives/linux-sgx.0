Return-Path: <SRS0=WPzH=U4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A44C5B57B
	for <linux-sgx@archiver.kernel.org>; Sat, 29 Jun 2019 23:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03B6321726
	for <linux-sgx@archiver.kernel.org>; Sat, 29 Jun 2019 23:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561852013;
	bh=m7JiaOc8uLjHzqJHjyTPWc76HXtqun5q862Jdn9emXA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=h1Gf/5yBLS7cshGqY0mb6B6n+j1jsN5larjF9++XJOhIJccwMPSWfqxMVyGKUIKUR
	 RrpTtIqGHSfIbOvomD/L3my02Gmi2oKqqtWPM8xC25uLR+qGYu5/N+R2jzfv+iB8Pt
	 ysiwuekUtc/G3YmSc97HBABjnkhq1NiHIBLCaY0E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfF2Xqw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 29 Jun 2019 19:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbfF2Xqw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 29 Jun 2019 19:46:52 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74102217D7
        for <linux-sgx@vger.kernel.org>; Sat, 29 Jun 2019 23:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561852011;
        bh=m7JiaOc8uLjHzqJHjyTPWc76HXtqun5q862Jdn9emXA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=zpW4HQmR459p8kugiYS2y2Xe/ym7lLJdk36xAN6iLgBcbsfiX+p63m5veuGXpizbA
         25r9uBaFH8Tbj0hxwbHLyUTEc8iJkWILcO2huEUrwD+X6uUJlhEcw26bSr2iChvj21
         cyO9svxL+i+PMuM75dyryQ6180Mu/kUB9gOYtnI4=
Received: by mail-wr1-f45.google.com with SMTP id x4so9912626wrt.6
        for <linux-sgx@vger.kernel.org>; Sat, 29 Jun 2019 16:46:51 -0700 (PDT)
X-Gm-Message-State: APjAAAUR0HcFc55mEMY8q24f5SfxYb6afbK1nmUgzizIaPNCaUVA5D7x
        nVVZFbYKHpKkI4uUJhI8V5xogHexpk0lkP3HWOjomQ==
X-Google-Smtp-Source: APXvYqzofs1nCSaOg4mX/lrKS3QLuWzVK5IU02OHCP4Aptlfby8fTI1WtJcnsq+OD1I3WGtdv5l9yawertL3GggF7W4=
X-Received: by 2002:adf:a143:: with SMTP id r3mr3393764wrr.352.1561852009958;
 Sat, 29 Jun 2019 16:46:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <cover.1561588012.git.cedric.xing@intel.com> <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
In-Reply-To: <72420cff8fa944b64e57df8d25c63bd30f8aacfa.1561588012.git.cedric.xing@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 29 Jun 2019 16:46:38 -0700
X-Gmail-Original-Message-ID: <CALCETrWQUEEwAAdPrVQMengKDhX3-fVrtJwaP2i=mWD+s+B8vg@mail.gmail.com>
Message-ID: <CALCETrWQUEEwAAdPrVQMengKDhX3-fVrtJwaP2i=mWD+s+B8vg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/3] x86/sgx: Add SGX specific LSM hooks
To:     Cedric Xing <cedric.xing@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr. Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 27, 2019 at 11:56 AM Cedric Xing <cedric.xing@intel.com> wrote:
>
> SGX enclaves are loaded from pages in regular memory. Given the ability t=
o
> create executable pages, the newly added SGX subsystem may present a back=
door
> for adversaries to circumvent LSM policies, such as creating an executabl=
e
> enclave page from a modified regular page that would otherwise not be mad=
e
> executable as prohibited by LSM. Therefore arises the primary question of
> whether an enclave page should be allowed to be created from a given sour=
ce
> page in regular memory.
>
> A related question is whether to grant/deny a mprotect() request on a giv=
en
> enclave page/range. mprotect() is traditionally covered by
> security_file_mprotect() hook, however, enclave pages have a different li=
fespan
> than either MAP_PRIVATE or MAP_SHARED. Particularly, MAP_PRIVATE pages ha=
ve the
> same lifespan as the VMA while MAP_SHARED pages have the same lifespan as=
 the
> backing file (on disk), but enclave pages have the lifespan of the enclav=
e=E2=80=99s
> file descriptor. For example, enclave pages could be munmap()=E2=80=99ed =
then mmap()=E2=80=99ed
> again without losing contents (like MAP_SHARED), but all enclave pages wi=
ll be
> lost once its file descriptor has been closed (like MAP_PRIVATE). That sa=
id,
> LSM modules need some new data structure for tracking protections of encl=
ave
> pages/ranges so that they can make proper decisions at mmap()/mprotect()
> syscalls.
>
> The last question, which is orthogonal to the 2 above, is whether or not =
to
> allow a given enclave to launch/run. Enclave pages are not visible to the=
 rest
> of the system, so to some extent offer a better place for malicious softw=
are to
> hide. Thus, it is sometimes desirable to whitelist/blacklist enclaves by =
their
> measurements, signing public keys, or image files.
>
> To address the questions above, 2 new LSM hooks are added for enclaves.
>   - security_enclave_load() =E2=80=93 This hook allows LSM to decide whet=
her or not to
>     allow instantiation of a range of enclave pages using the specified V=
MA. It
>     is invoked when a range of enclave pages is about to be loaded. It se=
rves 3
>     purposes: 1) indicate to LSM that the file struct in subject is an en=
clave;
>     2) allow LSM to decide whether or not to instantiate those pages and =
3)
>     allow LSM to initialize internal data structures for tracking
>     origins/protections of those pages.
>   - security_enclave_init() =E2=80=93 This hook allows whitelisting/black=
listing or
>     performing whatever checks deemed appropriate before an enclave is al=
lowed
>     to run. An LSM module may opt to use the file backing the SIGSTRUCT a=
s a
>     proxy to dictate allowed protections for anonymous pages.
>
> mprotect() of enclave pages continue to be governed by
> security_file_mprotect(), with the expectation that LSM is able to distin=
guish
> between regular and enclave pages inside the hook. For mmap(), the SGX
> subsystem is expected to invoke security_file_mprotect() explicitly to ch=
eck
> protections against the requested protections for existing enclave pages.=
 As
> stated earlier, enclave pages have different lifespan than the existing
> MAP_PRIVATE and MAP_SHARED pages, so would require a new data structure o=
utside
> of VMA to track their protections and/or origins. Enclave Memory Area (or=
 EMA
> for short) has been introduced to address the need. EMAs are maintained b=
y the
> LSM framework for all LSM modules to share. EMAs will be instantiated for
> enclaves only so will not impose memory/performance overheads for regular
> applications/files. Please see include/linux/lsm_ema.h and security/lsm_e=
ma.c
> for details.
>
> A new setup parameter =E2=80=93 lsm.ema.cache_decisions has been introduc=
ed to offer
> the choice between memory consumption and accuracy of audit logs. Enablin=
g
> lsm.ema.cache_decisions causes LSM framework NOT to keep backing files op=
en for
> EMAs. While that saves memory, it requires LSM modules to make and cache
> decisions ahead of time, and makes it difficult for LSM modules to genera=
te
> accurate audit logs. System administrators are expected to run LSM in
> permissive mode with lsm.ema.cache_decisions off to determine the minimal
> permissions needed, and then turn it back on in enforcing mode for optima=
l
> performance and memory usage. lsm.ema.cache_decisions is on by default an=
d
> could be turned off by appending =E2=80=9Clsm.ema.cache_decisions=3D0=E2=
=80=9D or
> =E2=80=9Clsm.ema.cache_decisions=3Doff=E2=80=9D to the kernel command lin=
e.

Just on a very cursory review, this seems like it's creating a bunch
of complexity (a whole new library and data structure), and I'm not
convinced the result is any better than Sean's version.
