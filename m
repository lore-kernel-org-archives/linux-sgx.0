Return-Path: <SRS0=2c9w=T6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 006E8C28CC0
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 15:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3AE724CE2
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 15:04:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="qXS+JXcJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfE3PEd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 30 May 2019 11:04:33 -0400
Received: from usfb19pa16.eemsg.mail.mil ([214.24.26.87]:17970 "EHLO
        usfb19pa16.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfE3PEd (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 30 May 2019 11:04:33 -0400
X-EEMSG-check-017: 199864528|USFB19PA16_EEMSG_MP12.csd.disa.mil
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by usfb19pa16.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 30 May 2019 15:04:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1559228671; x=1590764671;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Gx/Na3NMPNgR6X0ozLsN6rip3MeDz+5aRP/AalAyVLs=;
  b=qXS+JXcJhypwvQl8jqmPWuZGkpax6bjF9ZnTHHLwQNY3i5sY95e1NmhQ
   Yt6QJnPuNEcROTrMd/3aLzArXIhWc2q46KFWJ3I9J9muL+mj3whH9DT2a
   B4pVL6mNbxoSQOxXO4Fs4nNIjSl7rlDkSHGtWin0TCrPz5R9Xt07yJnv2
   yJxzCl0zOouc500mNIJHBOimtSfLMm0kpoyNK2FVB50WJQ7pRQq/gH3NG
   r6agZm9D/LVuo4duVG58HDeZH1viVOOmXGq8ZX/JJUri//bjQSBHVQW6E
   UezS3cGFIHurVqsKVU9N7jmR4X0bFCrKB6ssJna14kbYjpX0j4hCW50Da
   g==;
X-IronPort-AV: E=Sophos;i="5.60,531,1549929600"; 
   d="scan'208";a="24226989"
IronPort-PHdr: =?us-ascii?q?9a23=3AOn0ODR0hIG1YJyqQsmDT+DRfVm0co7zxezQtwd?=
 =?us-ascii?q?8ZsegQKv7xwZ3uMQTl6Ol3ixeRBMOHsqsC0rCH+PC4EUU7or+5+EgYd5JNUx?=
 =?us-ascii?q?JXwe43pCcHRPC/NEvgMfTxZDY7FskRHHVs/nW8LFQHUJ2mPw6arXK99yMdFQ?=
 =?us-ascii?q?viPgRpOOv1BpTSj8Oq3Oyu5pHfeQpFiCegbb9oMRm6swHcusYVjId+N6081g?=
 =?us-ascii?q?bHrnxUdupM2GhmP0iTnxHy5sex+J5s7SFdsO8/+sBDTKv3Yb02QaRXAzo6PW?=
 =?us-ascii?q?814tbrtQTYQguU+nQcSGQWnQFWDAXD8Rr3Q43+sir+tup6xSmaIcj7Rq06VD?=
 =?us-ascii?q?i+86tmTgLjhTwZPDAl7m7Yls1wjLpaoB2/oRx/35XUa5yROPZnY6/RYc8WSW?=
 =?us-ascii?q?9HU8lfTSxBBp63YZUJAeQPIO1Uq5DxqlsKoBe7AwSnGeHhxSJShnLuwKM0ze?=
 =?us-ascii?q?ohHwHF0gIuEd0Bv3bbo8n6OqoJTeC4zrPFwSnfY/5Y2zrw7pXDfBA7ofGLWL?=
 =?us-ascii?q?J9adffyVUxGAPdjlWft4rlNC6I2OQIqWeb6+5gWvyvimU6rAxxuSWgxtw3h4?=
 =?us-ascii?q?nVhoMa1lDE9SJjzIYzPt23UlR3YdGjEJtOriyXMZZ9TMA6Q2xwpSo3xbILtY?=
 =?us-ascii?q?S7cSQX0pgr2RHSZ+Kdf4SV5B/oSfyfLi1ihH1/fbKynxOy8U+9xeLiTsS0y1?=
 =?us-ascii?q?NKrjZdktnLq3ANywTf6siZRft5+UeswSqP2BrJ6uFFPEA0jrDXK4Ihw7Eslp?=
 =?us-ascii?q?oTtl7PHinql0XtkKCabEAk+ums6+j/Y7XmoIGTN5Nshw3jPakjldazDOQlPg?=
 =?us-ascii?q?QUQWSW9vqw2Kf+8UHhRbVFlPw2kq3XsJDAIsQbo7a0AxRI3YY48Bu/Ezen38?=
 =?us-ascii?q?gYnXkANl5FfgmHgJLzN1HBJ/D4E++zg06wnzdz2/DGIrrhD43JLnjejLfheq?=
 =?us-ascii?q?1w601Cxwopy9BQ+ZZUBqsGIPLpVU/7rMbYAQMhMwyo3+bnD81w2Z8AVm2SGK?=
 =?us-ascii?q?+ZMb/dvUWH5+IuJemMa5QYuDf7K/g5+fHuiWU1lkMafamsxZEXcmy3Hux6I0?=
 =?us-ascii?q?WFZnrhmswBHnkQsQo4VuDqikeOXiJTZ3aoXqI8/S07CIW+DYfDWI+tmqeB3C?=
 =?us-ascii?q?C9HpBNZ2BGDEyMHmnsd4meR/gMbyeSKNd7kjMYTbihV5Mh1Ra2uQDhyrpnKu?=
 =?us-ascii?q?7U9jcEup75zth14Pbcmg8o9TxoFMSQyG6NT2RukWMJQz86xrxwoUt4yl2by6?=
 =?us-ascii?q?h3n+RYFcBP5/NOSgo6N4TTz/Z5C9DxXQLNZMyJR0ylQtWlADExSMw+w9kVbk?=
 =?us-ascii?q?Z5GtWiiA3D3iWwD78UkbyLGII78qbG03ftIMZ9zm7M1LM9gFk+XstPKWqmi7?=
 =?us-ascii?q?Z99wjWAI7JiV+Zl6exdakH2i7C7mKDwnSPvE1CVw5wS6rFV2gFZkTKtdT5+l?=
 =?us-ascii?q?/CT7i2BLQ8LARB08GCJbVRZ93pl1pGQPPjOdTYY26rh2iwAhOIzKuWbIX2Y2?=
 =?us-ascii?q?UdwDndCE8cngAX/HaGMxU+Byi4r2LFEjNhCU/vY1nt8eliqHK3V0o0zwaXYE?=
 =?us-ascii?q?1807q65AUYheKTS/wNxLIIoiQhpCtuHFa7wd3WD8CMpw17fKVTedk9+ktI1X?=
 =?us-ascii?q?rFtwxhOZytN7hiiUQDcwRzpE7uzw94CphEkcQzqXMqyw1yKbiG319bazyY2p?=
 =?us-ascii?q?XwMKXNKmbu5BCvd7LW2lbG3dmI4qcA8u44q1T4vAyyDkot6W9n09hO03uE4p?=
 =?us-ascii?q?XFFhYdXozrXkYw7Rh6qKnQYjMh6IPMyX1sLa60vyfZ2903AOslyxCgf8pQMa?=
 =?us-ascii?q?6fCg/yHNMVB9K0JOwphVepdBQEM/5W9KIuOMOmbfSG0raxPOl8hDKmkXhH4I?=
 =?us-ascii?q?dl30KO6SV8Vu7I34wCw/yD0AuHUC38jEu7vcDxmIBFaiseEXa4ySjhHIRRfL?=
 =?us-ascii?q?F9fZ4XCWeyJM263shxiITzW3FG7lKjB0kJ2MmyeRWMaVzwxgxQ1UILoXO5nS?=
 =?us-ascii?q?u01SB7kzYsrqCHxizB3/zidAYbOm5MXGRikVjsIYy7jt0BWEiobg4plAa55U?=
 =?us-ascii?q?bgwKhboqV/LmbJTUhVYSf8N3tiXbeotrqef85P74slsSpNUOuiblCXUaDyox?=
 =?us-ascii?q?0Y0yz9G2tewDE7eC2wtprlmBx6jXqXLGxvo3rBZcFw2RDf6cTARf5WxDoGWj?=
 =?us-ascii?q?N3iT3KCVinJNSp+dSUl5HesuGxTm6hWJpTcTTtzYydriS7+WxqARq5n/ypnd?=
 =?us-ascii?q?3nCwc62zfh19Z2TSXIsAr8Yo7z2qS+MOJneFRoBVDl58p5BI5+iI0wi48U2X?=
 =?us-ascii?q?UBmJWV8mQIkX3pPdVYx63+dnwNSiAPw9LP5wjlwkJjJGqTx43lTnWd3tdhZ9?=
 =?us-ascii?q?6ib2IZ2S8w7ttHCKSK47xemyt6vF64oRjWYfhnkTcX0eEu52ICg+EVpAotyT?=
 =?us-ascii?q?2QArQTHUleICztmA2E78uxrKRYf2uvb7ew21Rkndy7D7GNvBtcWHDndZcmBy?=
 =?us-ascii?q?Nw6d9/MF3U2n3p9o7kYMXQbc4UthCMiRjAjPBVKJcqm/oOhCpnP3/9vHI8x+?=
 =?us-ascii?q?41ihxuwJe6s5WdJGVx/aK5BRhYOifyZ8MJ9THnlbxekdqO34CzApVhHS0GXJ?=
 =?us-ascii?q?3oTfKvCjISsO7oNwCVHT0mtHiUBLrfEhWD6Et8s33PFJWrPWmNJHYF1dViWA?=
 =?us-ascii?q?WdJEtHjQASRDU6m4I2GRywy8zldEd5+zUR60XiqhRS1+1oNwPwUnvFqAi0bT?=
 =?us-ascii?q?c0TYCVLABK4QFa+0fVLcue4/poHy5G5J2hoxKCJnaBaAVICmEJR0qECkviPr?=
 =?us-ascii?q?mo+dnP7eyYCvCiIPvJZLWEsfZeWOuQxZKzzotm+C6BNt6PPnZ4D/w3wElDUm?=
 =?us-ascii?q?plG8XYgjkOSjYYlyfMb86Bvxq8+yt3rtyh//TvQg7g+YyPC75KO9V15x+2mb?=
 =?us-ascii?q?uDN/KXhCthKTZXzJIMxWPSx7gYxlISizxueCOrEbQPriPNTaTQmrNJAB4fcS?=
 =?us-ascii?q?98KMxI76ck1AlXJcHbks/11qJ/jvMtEVhFU0HumtuoZc0KOW29L1PHC1iVNL?=
 =?us-ascii?q?uaJT3E3cf3YaC7SbBLiOVUthuwuSuUEkP5PzSDkSXpWA6rMe1WkC6bOxlesp?=
 =?us-ascii?q?mnchlxEWjjUM7mahqjPd90lzI2wKc4hmjUNWEGMTh8dVhArryW7SNEnPp/H3?=
 =?us-ascii?q?ZN4WZiLemBgyyZ9fXXKo4Ksft3BSR5j/lV4GwhxrRP6CFEReJ6mC3Ro9J0vl?=
 =?us-ascii?q?6pjPGFyiB7XxpWtjZLmIWLsF1gOaXe7ZlAWW3J/BAK7WWLCxQKu8FlCtz3u6?=
 =?us-ascii?q?BU1NfPiL7zJC1F89LO8ssWH9LUJ96fMHo9LRrpHybZDAgfQj6qL23fh1Fdn+?=
 =?us-ascii?q?uU9n2atZU6q57smIYQRb9fTlA6CvQaCkF9FtwYPJh3Ri8kkaKcjMMQ/3q+rQ?=
 =?us-ascii?q?feRMNGvpDFSP2SGu7iKDmejblDaBsIxa33IZ4POY383kwxImV9ya3MF1uYec?=
 =?us-ascii?q?1RpShgdBQ3oQ0Z9GViSUUw1ljjZwfr52UcQ62ahBkz3zBibPwt+TGk2FI+Il?=
 =?us-ascii?q?7HtWNki0Uqscn0ijCWNjjqJeG/Wp8AWHm8jFQ4Lp6uG1U9Vga1h0ExcW6ZFr?=
 =?us-ascii?q?8=3D?=
X-IPAS-Result: =?us-ascii?q?A2DoAQCg8O9c/wHyM5BlHAEBAQQBAQcEAQGBVAQBAQsBg?=
 =?us-ascii?q?WYqgW2EPJMCTwEBAQaBECV+iFKRBwkBAQEBAQEBAQE0AQIBAYRAAoJ9IzcGD?=
 =?us-ascii?q?gEDAQEBBAEBAQEDAQFsKII6KQGCZgEBAQECASMEEUEFCwsOCgICJgICVwYNC?=
 =?us-ascii?q?AEBgl8/gXcFD6oyfDOFR4MpgUaBDCgBi1UXeIEHgREnDIIqNT6HToJYBI1jh?=
 =?us-ascii?q?giVAQmCD4IWkQcGG4IhlDeOIJZtIoFYKwgCGAghD4MokG0jA4E2AQGNfQEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 30 May 2019 15:04:28 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x4UF4O2M030622;
        Thu, 30 May 2019 11:04:24 -0400
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Andy Lutomirski <luto@kernel.org>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        William Roberts <bill.c.roberts@gmail.com>,
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
 <285f279f-b500-27f0-ab42-fb1dbcc5ab18@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F654EB487@ORSMSX116.amr.corp.intel.com>
 <678a37af-797d-7bd5-a406-32548a270e3d@tycho.nsa.gov>
 <CALCETrWXB9fNNDH7gZxPTx05F78Og6K=ZtAr2aA++BDwY09Wbg@mail.gmail.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <c1135352-0b5e-4694-b1a9-105876095877@tycho.nsa.gov>
Date:   Thu, 30 May 2019 11:04:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CALCETrWXB9fNNDH7gZxPTx05F78Og6K=ZtAr2aA++BDwY09Wbg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/30/19 10:31 AM, Andy Lutomirski wrote:
> Hi all-
> 
> After an offline discussion with Sean yesterday, here are some updates
> to the user API parts of my proposal.
> 
> Unfortunately, Sean convinced me that MAXPERM doesn't work the way I
> described it because, for SGX2, the enclave loader won't know at load
> time whether a given EAUG-ed page will ever be executed.  So here's an
> update.
> 
> First, here are the requrements as I see them, where EXECUTE, EXECMOD,
> and EXECMEM could be substituted with other rules at the LSM's
> discretion:
> 
>   - You can create a WX or RWX mapping if and only if you have EXECMEM.
> 
>   - To create an X mapping of an enclave page that has ever been W, you
> need EXECMOD.

EXECMOD to what file? The enclave file from which the page's content 
originated, the sigstruct file, or /dev/sgx/enclave?

>   - To create an X mapping of an enclave page that came from EADD, you
> need EXECUTE on the source file.  Optionally, we could also permit
> this if you have EXECMOD.

What is the "source file" i.e. the target of the check?  Enclave file, 
sigstruct file, or /dev/sgx/enclave?

> 
> And I have two design proposals.  One is static and one is dynamic.
> To implement either one, we will probably need a new .may_mprotect vm
> operation, and that operation can call an LSM hook.  Or we can give
> LSMs a way to detect that a given vm_area_struct is an enclave.  As I
> see it, this is an implementation detail that is certainly solveable.
> 
> 
> Static proposal:
> 
> 
> EADD takes an execute_intent flag.  It calls a new hook:
> 
>    int security_enclave_load(struct vm_area_struct *source, bool execute_intent);
> 
> This hook will fail if execute_intent==true and the caller has neither
> EXECUTE, EXECMOD, nor EXECMEM.

EADD execute_intent flag is originally provided by whom (userspace or 
driver) on what basis? Which file is referenced by source->vm_file? Why 
trigger all three checks up front versus only checking if needed?  Won't 
this trigger a lot of unnecessary EXECMOD and EXECMEM denials that will 
need to be dontaudit'd? What if there is a mismatch between 
execute_intent and the initial permissions?

> 
> EAUG sets execute_intent = false.
> 
> EINIT takes a sigstruct pointer.  SGX can (when initially upstreamed
> or later on once there's demand) call a new hook:
> 
>    security_enclave_init(struct sigstruct *sigstruct, struct
> vm_area_struct *source);

Is struct sigstruct the same as struct sgx_sigstruct in the current 
patches (i.e. just the sigstruct data, no file)?  What file is 
referenced by source->vm_file (the sigstruct or the enclave or 
/dev/sgx/enclave)?  Is this hook only for enforcing a whitelist on what 
enclaves can be loaded?  What is the target of the check?

> mmap() and mprotect() will require EXECMEM to create WX or RWX
> mappings.  They will require EXECMOD to create RX or X mappings of an
> execute_intent==false page.  They require no permissions in the other
> cases.

Does this occur for both setting initial permissions and runtime 
permissions or just runtime? Both userspace- and driver-initiated 
mmap/mprotect operations or just userspace-initiated ones?  Does the 
driver use interfaces that call the mmap/mprotect hooks or lower level 
functions?

> 
> 
> Dynamic proposal:
> 
> 
> EADD does not take any special flags.  It does something like this internally:
> 
>    bool execute_intent = true;
>    int security_enclave_load(struct vm_area_struct *source, bool
> *execute_intent);
> 
> The implementation of security_enclave_load() may set *execute_intent to false.
> The driver records execute_intent after the LSM is done.

On what basis does LSM decide whether to set *execute_intent?  If the 
process lacks all three permissions? What if there is a mismatch with 
the initial permissions?

> 
> mmap() and mprotect() will require EXECMEM to create WX or RWX
> mappings.  They will require EXECMOD to create RX or X mappings of an
> execute_intent==false page.  They require no permissions in the other
> cases.
> 
> 
> 
> A benefit of the static proposal is that audit failures due to a lack
> of EXECUTE permission are easy to implement and to understand in the
> lods.  With the dynamic model, we can only really audit the lack of
> EXECMOD or EXECMEM.  A benefit of the dynamic model is that we hide
> what is arguably a decently large wart from the API.
> 

