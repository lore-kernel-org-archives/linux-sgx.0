Return-Path: <SRS0=WVIS=T5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA34C28CC0
	for <linux-sgx@archiver.kernel.org>; Wed, 29 May 2019 14:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AF9A2377D
	for <linux-sgx@archiver.kernel.org>; Wed, 29 May 2019 14:08:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="BhFu6n3a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfE2OIp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 29 May 2019 10:08:45 -0400
Received: from ucol19pa12.eemsg.mail.mil ([214.24.24.85]:3109 "EHLO
        UCOL19PA12.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfE2OIp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 29 May 2019 10:08:45 -0400
X-EEMSG-check-017: 23305220|UCOL19PA12_EEMSG_MP10.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.60,527,1549929600"; 
   d="scan'208";a="23305220"
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by UCOL19PA12.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 29 May 2019 14:08:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1559138916; x=1590674916;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=qsEZJB+/egMz1OkrliAs8131XfrUM2kDlDn+9eSJ/uQ=;
  b=BhFu6n3aKFKzbMnCH6Soh4caoJhTx3D0ckawv1hWro6BGcpwQqBDVKtd
   Io+zKCDipIBCZn6dOCfhXGmUX5B3anG5kptshVpA7wK5+DUPUpmlAHaog
   zoKggzlnmIHQ4G9Xkv7mby8+KRqs5Kt2E/MpAFZ2CFzqo+YjRSTyKesuu
   oANWRL438lx3wdNcgy6HuWQiP0D7lLjbOtpKeOOh8gI078DKphfY50n7x
   R2GB6NgLYs2l7S0MO5avGkmsPqQ3pKpq6E4JdfWcmgipc+k4Dl4O4Huzj
   +f3Ohn1KjVXMIvN4CzawZXnqLq4ggwJzO6/I7eo+JUWHmC0i/Jruv8mqP
   Q==;
X-IronPort-AV: E=Sophos;i="5.60,527,1549929600"; 
   d="scan'208";a="24171742"
IronPort-PHdr: =?us-ascii?q?9a23=3Al5luhREx4RmbgnQyE3ZOJp1GYnF86YWxBRYc79?=
 =?us-ascii?q?8ds5kLTJ75oMy8bnLW6fgltlLVR4KTs6sC17OP9fm6BidfuN6oizMrSNR0TR?=
 =?us-ascii?q?gLiMEbzUQLIfWuLgnFFsPsdDEwB89YVVVorDmROElRH9viNRWJ+iXhpTEdFQ?=
 =?us-ascii?q?/iOgVrO+/7BpDdj9it1+C15pbffxhEiCCybL9vMRm6txjdutcUjIdtKKs91w?=
 =?us-ascii?q?bCr2dVdehR2W5mP0+YkQzm5se38p5j8iBQtOwk+sVdT6j0fLk2QKJBAjg+PG?=
 =?us-ascii?q?87+MPktR/YTQuS/XQcSXkZkgBJAwfe8h73WIr6vzbguep83CmaOtD2TawxVD?=
 =?us-ascii?q?+/4apnVAPkhSEaPDMi7mrZltJ/g75aoBK5phxw3YjUYJ2ONPFjeq/RZM4WSX?=
 =?us-ascii?q?ZdUspUUSFODJm8b48SBOQfO+hWoZT2q18XoRegAQSgAeXiwSJKiHDrx603y/?=
 =?us-ascii?q?kvHx/I3AIgHNwAvnrbo9r3O6gOXu6417XIwDbZYv9KxTvw5orFfxY8qv+MR7?=
 =?us-ascii?q?Jwds/RxFEyGQPZkFqQsYzlMC2T1u8Qrmab6vBvVeari2E5qwB6vz+ixtwxhY?=
 =?us-ascii?q?nSnY8V1lDF+jl5wIYyP9G4TlV7bsS+HJtfsCGaKZJ7T8U/SG9roCY30qAKtJ?=
 =?us-ascii?q?G0cSQQyJkr2gTTZ+KIfoSW+B7vSeCcKipiin1/YrKwnROy/FClyu37S8a7zk?=
 =?us-ascii?q?5HrjFAktnQrnAN0AHT6tSfRvt94Eih3TGP2hjP6u5eO0A0lLfbK4U7zr4slp?=
 =?us-ascii?q?scrUTDHijslEXwkKCWbVkr9vKt6+TmZrXqvp6cN4lqhQHiKqkih8OyDOsiPg?=
 =?us-ascii?q?UOQmSX4/qw2bL98UHjXblGlvg2nbPYsJDeK8QbvKm5AwpN34Y49hm/FCyr0M?=
 =?us-ascii?q?gYnHYbLFJFfwiLj47yO17UOvz4AvC/g0q0nDdx2//GJqHhAonKLnXbi7fuY6?=
 =?us-ascii?q?xy60hGxAox19xQ+5JUCqsAIPLoRk/xs8TYDh8nPAyu2ObnD9N925gfWWKJHq?=
 =?us-ascii?q?+WLqfSvUWU6eIoJumGfJUVtyrlK/g5+/7uimc0lkMDcqa0x5sXaWy3Eu5pIk?=
 =?us-ascii?q?WYZ3rsjcwMEWYMvgoiUuPqjEeOXiJUZ3a3R6g8/C00CJq6DYffQYCgmKeO3C?=
 =?us-ascii?q?a/Hp1SfGxJFkqAEW3vd4qfRfgMcj6SItR6nzwLULiuUY4h1RW0uADmzLpnK/?=
 =?us-ascii?q?Le+jcEupL7yNh1++rTmAk29TxpE8Sd1HqAT2JqkWMSQT85wqR/rVZ6yleZ3q?=
 =?us-ascii?q?hym+ZYGsBL5/NVTgc6MobRz+5gBNDoWQLBfdCJREy9Qtq8AjExTdMxw9kQbE?=
 =?us-ascii?q?Z7ANiiihHD3yy3A74ajbCLBZo08r7C0Hj1Pcpy13HG1Kw5hVk8XsRPLXGmhr?=
 =?us-ascii?q?J49wXLBY7JlkKZl7ywdaQdxy7A72GDwnCLvE5GUQ58S6LFXWoQZkHOt9T2+l?=
 =?us-ascii?q?vCT6OyCbQgKgZB0tCNKrFFatL3llhGRO3sONDaY2OxnWe8HwqHxrSJbIDyYW?=
 =?us-ascii?q?USwD3dCFQYkwAU5XuGMQk+BiG8o2PRFTBuDkzgbF/x8elkqXO7Uk81wxiPb0?=
 =?us-ascii?q?1myrW15xoViuKHRvMN0bILpj0hpy93HFmjxdLWDcSPpw57cKVbe9M9709N1X?=
 =?us-ascii?q?jFuAxlIpygM6dii0YGcwttokPu0w56Cp1ansg3qHMm1Q9yKaWf0FNbaTyUx4?=
 =?us-ascii?q?z/OrrSKmPq5hCgd7bW2k3C0NaR4qoA9uw4pE/5vAGoDUov6G1n3MNP03ud/Z?=
 =?us-ascii?q?XKFA4SXojtXUkp7RR6oKvaYiYl7YPOyXJsKbW0siPF298xH+sq1BKgf9ZZMK?=
 =?us-ascii?q?OZGw7/CNMaB8ewJ+wwgVSpbQwLPPpU9KEqO8OqbfyG2LSkPOx4hjKpkXxH4J?=
 =?us-ascii?q?xh0kKL7yd8SPDH34oFw/GC2QuKTDn8jFC7ssDrg49EYzASH2WlxSf4A45RY7?=
 =?us-ascii?q?V4fZwXBme2P8232tJ+iobwVHFC6l6sGUkK2M+zdhqUdFzywwtQ2F8WoXyhhS?=
 =?us-ascii?q?u30Th0nys1oaqY2SzE2/7iewYfOm5XWGliik/hIZS7j9AeU0mldAwplBqj5U?=
 =?us-ascii?q?bn26hbvqN/L2/SQUZHZST5Mn9tWLOqtrWee85P9I8osSJPXeSze1CVVLH9rg?=
 =?us-ascii?q?AE3CPlHWtR2jQ7dzWruprlhRB1lGWdLHNrpnrDZc5w3Qvf5MDbRfNJwjoGQz?=
 =?us-ascii?q?N4iSfNCVi4Itap5s6Zl5PCsuC4SmKgWYRfcSfszYOdsiu0+HdlAQG+n/C0nN?=
 =?us-ascii?q?3rCw860TX019NyTyXHsA78YpX316S9Ke9nekhoBFnh68t1A41+kZU/hIsW2X?=
 =?us-ascii?q?cEgpWY5mQHkWjtPtVBw67+b2QCRSQNw9HL5AjpwkpjLmiGx4jhTHWS3tNhZ8?=
 =?us-ascii?q?WmYmMRwi884MNHBaaP4bxHgyR1uFy4ohzVYfRnmTcd0/Qu4mYAg+4VoAot0j?=
 =?us-ascii?q?mdArcKEElcPCzskQmI7t+noKVMa2aufqO91FRxnd+/FrGOuAJcV2jjepckAy?=
 =?us-ascii?q?Bw6t9zMFXW0H388ovkYsXfbcoPth2IlBfNl/JaKJEplvoPnidnPWP9vXs4y+?=
 =?us-ascii?q?80lBBu05a6vJWBK2pw5q25Hh9YNjrzZ88J/THtl6lelN6M34+zBpVhBikLXJ?=
 =?us-ascii?q?zwQPKuEDISsu7nNwOUHz06sXqbA6TQEhKf6Eh8s3LDCYykN3aSJHMB19VtWA?=
 =?us-ascii?q?GdJFBDgAATRDg6mIY5FgW2y8P9akh54jQR5kP9qhZX0OJnKQTwUmfFqwe0cD?=
 =?us-ascii?q?s7VJ+fLB9O5AFY+0jVKdCe7v50HyxA5Z2ushaNKmOFaAhSF24IWkuEB03lPr?=
 =?us-ascii?q?S15NnA9fSYCfS6L/fUfbqOruleXe+SxZ2zyotm4yqMNsKXM3l5D/00wEpCUW?=
 =?us-ascii?q?p6G8vDhzUOSjUbliPXYM6epRe84DZ6rsG58PT3Rg3v4ZGDBKdVMdVq4xq2m7?=
 =?us-ascii?q?uMN/aMhCZlLjZVzpMMymXJyLgDxlESjDtidzmwEbsasy7NQ7ndmq5RDx4HdS?=
 =?us-ascii?q?xzMNFE4L473glIIcTbkM/61qZkjv4pDFdITUbumse0aswQImG8NEnLBF2LNL?=
 =?us-ascii?q?uYOz3E38H3br26Sb1Ti+VZrBmwuTedE0/+MTWPjTjpVxazMe5SiCGXJgBRuI?=
 =?us-ascii?q?a4chx1E2jsUMrmagGnMN9wlTA2wqc7hnLQOW4HLzhzaUNNrruL4CNZhPV/B3?=
 =?us-ascii?q?JO7n5/IeaYnCaZ6vHSKowKvvtzHiR0i+Va7WwhxLtN9yxLXvh1mCrMod5ooF?=
 =?us-ascii?q?yqiPSAxSR/WhpUtjlLnJ6LvVllOajB9JlAXm3E/BIW4GWSDBQKvNtlCsH1u6?=
 =?us-ascii?q?BR0tjPkLz8KCte897O+sscHcfUItqdMHU9KRrpBCLUDAwdQD6oL27fhlZRkP?=
 =?us-ascii?q?GP9nKPqJg6pYPhmJsISr9HSlM1EukWBVhiHNwHOJ13RC8rkaaHjM4U4nqztA?=
 =?us-ascii?q?PRRMREsZDBSvKSA+vgKC2CgLlLYBsIxrz4LYANOYHhx0NibVx6z8z2HB/rUN?=
 =?us-ascii?q?lL6gZhdA4vvEJV8HVkVWo1kxb+Zwqrpn1VHv6unwUqjRN+bP428zHE4lErK1?=
 =?us-ascii?q?6Mryw1xg150+Xkhz/VOBX8IL2xVsseXyH5u1IwOdXrQgB6RQy0gUFgcjzDQu?=
 =?us-ascii?q?QVx4RhcWRqgQqUg5xFFORAVuUQah4UwbecIe8v21lGtj6PykpO5O+DApxnwl?=
 =?us-ascii?q?gEa5mp+klc1hpjYdh9HqnZIK5E3xAEna6VljO53eA2hgkFLgAC933EK31Ag1?=
 =?us-ascii?q?ABKrRzf3ngxedr8wHX3mIZKWU=3D?=
X-IPAS-Result: =?us-ascii?q?A2BsAADukO5c/wHyM5BlGQEBAQEBAQEBAQEBAQcBAQEBA?=
 =?us-ascii?q?QGBZYFnKoFtKIQTk1ABAQEBAQEGgTV+iFKRBgkBAQEBAQEBAQE0AQIBAYFLg?=
 =?us-ascii?q?nUCgnUjOBMBAwEBAQQBAQEBAwEBbCiCOikBgmYBAQEBAgEjBAsBBUEQCxUBA?=
 =?us-ascii?q?gICFQIMAwICRhEGAQwGAgEBgl8/gXcFD6lVfDOFR4MpgUaBDCiLUxd4gQeBE?=
 =?us-ascii?q?SeCNjU+hRsHgiyCWASLMRKCG4coknBqCYIPghOIcIgWBhuCH4ZphAGFXoMEa?=
 =?us-ascii?q?Ix1mA8hgVcrCAIYCCEPO4JsghsXjjwjAzCBBgEBYIoPglABAQ?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 29 May 2019 14:08:35 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x4TE8PcT014613;
        Wed, 29 May 2019 10:08:25 -0400
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        William Roberts <bill.c.roberts@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
References: <20190524175458.GB365@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8E1D@ORSMSX116.amr.corp.intel.com>
 <CALCETrUw5sEr-MHPMU4CzEzkrejDs-JOThHB9Buhoxo5-rdpRw@mail.gmail.com>
 <20190524200333.GF365@linux.intel.com>
 <CALCETrUyAAhnQ+RUeN1L41TKj-vcD2CNt-FJ9siO=Zo6gvH1Aw@mail.gmail.com>
 <20190524224107.GJ365@linux.intel.com>
 <683B5E3D-AFB6-4B45-8D39-B00847312209@amacapital.net>
 <960B34DE67B9E140824F1DCDEC400C0F654E965F@ORSMSX116.amr.corp.intel.com>
 <CALCETrXXVMutX8eZk6nnkOAeS+Tj0sQd0FkW+wk6Rx8hQxCe6w@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E9824@ORSMSX116.amr.corp.intel.com>
 <20190528202407.GB13158@linux.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <285f279f-b500-27f0-ab42-fb1dbcc5ab18@tycho.nsa.gov>
Date:   Wed, 29 May 2019 10:08:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190528202407.GB13158@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/28/19 4:24 PM, Sean Christopherson wrote:
> On Sat, May 25, 2019 at 11:09:38PM -0700, Xing, Cedric wrote:
>>> From: Andy Lutomirski [mailto:luto@kernel.org]
>>> Sent: Saturday, May 25, 2019 5:58 PM
>>>
>>> On Sat, May 25, 2019 at 3:40 PM Xing, Cedric <cedric.xing@intel.com> wrote:
>>>>
>>>> If we think of EADD as a way of mmap()'ing an enclave file into memory,
>>>> would this
>>> security_enclave_load() be the same as
>>> security_mmap_file(source_vma->vm_file, maxperm, MAP_PRIVATE), except that
>>> the target is now EPC instead of regular pages?
>>>
>>> Hmm, that's clever.  Although it seems plausible that an LSM would want to
>>> allow RX or RWX of a given file page but only in the context of an approved
>>> enclave, so I think it should still be its own hook.
>>
>> What do you mean by "in the context of an approved enclave"? EPC pages are
>> *inaccessible* to any software until after EINIT. So it would never be a
>> security concern to EADD a page with wrong permissions as long as the enclave
>> would be denied eventually by LSM at EINIT.
>>
>> But I acknowledge the difference between loading a page into regular memory
>> vs. into EPC. So it's beneficial to have a separate hook, which if not
>> hooked, would pass through to security_mmap_file() by default?
> 
> Mapping the enclave will still go through security_mmap_file(), the extra
> security_enclave_load() hook allows the mmap() to use PROT_NONE.
> 
>>> If it's going to be in an arbitrary file, then I think the signature needs to be more like:
>>>
>>> int security_enclave_init(struct vm_area_struct *sigstruct_vma, loff_t sigstruct_offset,
>>> const sgx_sigstruct *sigstruct);
>>>
>>> So that the LSM still has the opportunity to base its decision on the contents of the
>>> SIGSTRUCT.  Actually, we need that change regardless.
>>
>> Wouldn't the pair of { sigstruct_vma, sigstruct_offset } be the same as just
>> a pointer, because the VMA could be looked up using the pointer and the
>> offset would then be (pointer - vma->vm_start)?
> 
> VMA has vm_file, e.g. the .sigstruct file labeled by LSMs.  That being
> said, why does the LSM need the VMA?  E.g. why not this?
> 
>    int security_enclave_init(struct file *file, struct sgx_sigstruct *sigstruct);
> 
>>>> Loosely speaking, an enclave (including initial contents of all of its pages and their
>>> permissions) and its MRENCLAVE are a 1-to-1 correspondence (given the collision resistant
>>> property of SHA-2). So only one is needed for a decision, and either one would lead to the
>>> same decision. So I don't see anything making any sense here.
>>>>
>>>> Theoretically speaking, if LSM can make a decision at EINIT by means of
>>> security_enclave_load(), then security_enclave_load() is never needed.
>>>>
>>>> In practice, I support keeping both because security_enclave_load() can only approve an
>>> enumerable set while security_enclave_load() can approve a non-enumerable set of enclaves.
>>> Moreover, in order to determine the validity of a MRENCLAVE (as in development of a policy
>>> or in creation of a white/black list), system admins will need the audit log produced by
>>> security_enclave_load().
>>>
>>> I'm confused.  Things like MRSIGNER aren't known until the SIGSTRUCT shows
>>> up.  Also, security_enclave_load() provides no protection against loading a
>>> mishmash of two different enclave files.  I see security_enclave_init() as
>>> "verify this SIGSTRUCT against your policy on who may sign enclaves and/or
>>> grant EXECMOD depending on SIGSTRUCT" and security_enclave_load() as
>>> "implement your EXECMOD / EXECUTE / WRITE / whatever policy and possibly
>>> check enclave files for some label."
>>
>> Sorry for the confusion. I was saying the same thing except that the decision
>> of security_enclave_load() doesn't have to depend on SIGSTRUCT. Given your
>> prototype of security_enclave_load(), I think we are on the same page. I made
>> the above comment to object to the idea of "require that the sigstruct be
>> supplied before any EADD operations so that the maxperm decisions can depend
>> on the sigstruct".
> 
> Except that having the sigstruct allows using the sigstruct as the proxy
> for the enclave.  I think the last big disconnect is that Andy and I want
> to tie everything to an enclave-specific file, i.e. sigstruct, while you
> are proposing labeling /dev/sgx/enclave.  If someone wants to cram several
> sigstructs into a single file, so be it, but using /dev/sgx/enclave means
> users can't do per-enclave permissions, period.
> 
> What is your objection to working on the sigstruct?
> 
>>>>>> Passing both would allow tying EXECMOD to /dev/sgx/enclave as
>>>>>> Cedric wanted (without having to play games and pass
>>>>>> /dev/sgx/enclave to security_enclave_load()), but I don't think
>>>>>> there's anything fundamentally broken with using .sigstruct for
>>>>>> EXECMOD.  It requires more verbose labeling, but that's not a bad thing.
>>>>>
>>>>> The benefit of putting it on .sigstruct is that it can be per-enclave.
>>>>>
>>>>> As I understand it from Fedora packaging, the way this works on
>>>>> distros is generally that a package will include some files and
>>>>> their associated labels, and, if the package needs EXECMOD, then the
>>>>> files are labeled with EXECMOD and the author of the relevant code might get a dirty
>>> look.
>>>>>
>>>>> This could translate to the author of an exclave that needs RWX
>>>>> regions getting a dirty look without leaking this permission into other enclaves.
>>>>>
>>>>> (In my opinion, the dirty looks are actually the best security
>>>>> benefit of the entire concept of LSMs making RWX difficult.  A
>>>>> sufficiently creative attacker can almost always bypass W^X
>>>>> restrictions once they’ve pwned you, but W^X makes it harder to pwn
>>>>> you in the first place, and SELinux makes it really obvious when
>>>>> packaging a program that doesn’t respect W^X.  The upshot is that a
>>>>> lot of programs got fixed.)
>>>>
>>>> I'm lost here. Dynamically linked enclaves, if running on SGX2, would need RW->RX, i.e.
>>> FILE__EXECMOD on /dev/sgx/enclave. But they never need RWX, i.e. PROCESS__EXECMEM.
>>>
>>> Hmm.  If we want to make this distinction, we need something a big richer
>>> than my proposed callbacks.  A check of the actual mprotect() / mmap()
>>> permissions would also be needed.  Specifically, allowing MAXPERM=RWX
>>> wouldn't imply that PROT_WRITE | PROT_EXEC is allowed.
> 
> Actually, I think we do have everything we need from an LSM perspective.
> LSMs just need to understand that sgx_enclave_load() with a NULL vma
> implies a transition from RW.  For example, SELinux would interpret
> sgx_enclave_load(NULL, RX) as requiring FILE__EXECMOD.
> 
> As Cedric mentioned earlier, the host process doesn't necessarily know
> which pages will end up RW vs RX, i.e. sgx_enclave_load(NULL, RX)
> already has to be invoked at runtime, and when that happens, the kernel
> can take the opportunity to change the VMAs from MAY_RW to MAY_RX.
> 
> For simplicity in the kernel and clarity in userspace, it makes sense to
> require an explicit ioctl() to add the to-be-EAUG'd range.  That just
> leaves us wanting an ioctl() to set the post-EACCEPT{COPY} permissions.
> 
> E.g.:
> 
>      ioctl(<prefix>_ADD_REGION, { NULL }) /* NULL == EAUG, MAY_RW */
> 
>      mprotect(addr, size, RW);
>      ...
> 
>      EACCEPTCOPY -> EAUG /* page fault handler */
> 
>      ioctl(<prefix>_ACTIVATE_REGION, { addr, size, RX}) /* MAY_RX */
> 
>      mprotect(addr, size, RX);
> 
>      ...
> 
> And making ACTIVATE_REGION a single-shot per page eliminates the need for
> the MAXPERMS concept (see below).
> 
>> If we keep only one MAXPERM, wouldn't this be the current behavior of
>> mmap()/mprotect()?
>>
>> To be a bit more clear, system admin sets MAXPERM upper bound in the form of
>> FILE__{READ|WRITE|EXECUTE|EXECMOD} of /dev/sgx/enclave. Then for a
>> process/enclave, if what it requires falls below what's allowed on
>> /dev/sgx/enclave, then everything will just work. Otherwise, it fails in the
>> form of -EPERM returned from mmap()/mprotect(). Please note that MAXPERM here
>> applies to "runtime" permissions, while "initial" permissions are taken care
>> of by security_enclave_{load|init}. "initial" permissions could be more
>> permissive than "runtime" permissions, e.g., RX is still required for initial
>> code pages even though system admins could disable dynamically loaded code
>> pages by *not* giving FILE__{EXECUTE|EXECMOD}. Therefore, the "initial"
>> mapping would still have to be done by the driver (to bypass LSM), either via
>> a new ioctl or as part of IOC_EINIT.
> 
> Aha!
> 
> Starting with Cedric's assertion that initial permissions can be taken
> directly from SECINFO:
> 
>    - Initial permissions for *EADD* pages are explicitly handled via
>      sgx_enclave_load() with the exact SECINFO permissions.
> 
>    - Initial permissions for *EAUG* are unconditionally RW.  EACCEPTCOPY
>      requires the target EPC page to be RW, and EACCEPT with RO is useless.
> 
>    - Runtime permissions break down as follows:
>        R   - N/A, subset of RW (EAUG)
>        W   - N/A, subset of RW (EAUG) and x86 paging can't do W
>        X   - N/A, subset of RX (x86 paging can't do XO)
>        RW  - Handled by EAUG LSM hook (uses RW unconditionally)
>        WX  - N/A, subset of RWX (x86 paging can't do WX)
>        RX  - Handled by ACTIVATE_REGION
>        RWX - Handled by ACTIVATE_REGION
> 
> In other words, if we define the SGX -> LSM calls as follows (minus the
> file pointer and other params for brevity):
> 
>    - <prefix>_ACTIVATE_REGION(vma, perms) -> sgx_enclave_load(NULL, perms)
> 
>    - <prefix>_ADD_REGION(vma) -> sgx_enclave_load(vma, SECINFO.perms)
> 
>    - <prefix>_ADD_REGION(NULL) -> sgx_enclave_load(NULL, RW)
> 
> then SGX and LSMs have all the information and hooks needed.  The catch
> is that the LSM semantics of sgx_enclave_load(..., RW) would need to be
> different than normal shared memory, e.g. FILE__WRITE should *not* be
> required, but that's ok since it's an SGX specific hook.  And if for some
> reason an LSM wanted to gate access to EAUG *without* FILE__EXECMOD, it'd
> have the necessary information to do so.

Assuming that sgx_enclave_load() is a LSM hook (probably named 
security_enclave_load() instead), then:

a) Does the sigstruct file get passed to this hook in every case, even 
when vma is NULL?  I think the answer is yes, just want to confirm.

b) Should we use a different hook for ACTIVATE_REGION than for 
ADD_REGION or is the distinction between them irrelevant/unnecessary 
from an access control point of view? At present LSM/SELinux won't be 
able to distinguish ACTIVATE_REGION(vma, RW) from ADD_REGION(NULL) above 
since they will both invoke the same hook with the same arguments IIUC. 
Does it matter?  It's ok if the answer is no, just want to confirm.

c) Is there still also a separate security_enclave_init() hook that will 
be called, and if so, how does it differ and when is it called relative 
to security_enclave_load()?

d) What checks were you envisioning each of these calls making?

With the separate security_enclave_*() hooks, we could define and use 
new ENCLAVE__* permissions, e.g. ENCLAVE__LOAD, ENCLAVE__INIT, 
ENCLAVE__EXECUTE, ENCLAVE__EXECMEM, ENCLAVE__EXECMOD, if we want to 
distinguish these operations from regular file mmap/mprotect operations.

> 
> The userspace changes are fairly minimal:
> 
>    - For SGX1, use PROT_NONE for the initial mmap() and refactor ADD_PAGE
>      to ADD_REGION.
> 
>    - For SGX2, do an explicit ADD_REGION on the ranges to be EAUG'd, and an
>      ACTIVATE_REGION to make a region RX or R (no extra ioctl() required to
>      keep RW permissions).
> 
> Because ACTIVATE_REGION can only be done once per page, to do *abitrary*
> mprotect() transitions, userspace would need to set the added/activated
> permissions to be a superset of the transitions, e.g. RW -> RX would
> require RWX, but that's a non-issue.
> 
>    - For SGX1 it's a nop since it's impossible to change the EPCM
>      permissions, i.e. the page would need to be RWX regardless.
> 
>    - For SGX2, userspace can suck it up and request RWX to do completely
>      arbitrary transitions (working as intended), or the kernel can support
>      trimming (removing) pages from an enclave, which would allow userspace
>      to do "arbitrary" transitions by first removing the page.
> 

