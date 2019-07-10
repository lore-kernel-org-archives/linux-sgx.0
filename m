Return-Path: <SRS0=TOMN=VH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D55C74A35
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 23:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13A7B208C4
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 23:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbfGJXQn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Jul 2019 19:16:43 -0400
Received: from mga03.intel.com ([134.134.136.65]:52582 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbfGJXQn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Jul 2019 19:16:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 16:16:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,476,1557212400"; 
   d="scan'208";a="249615277"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by orsmga001.jf.intel.com with ESMTP; 10 Jul 2019 16:16:42 -0700
Subject: Re: [RFC PATCH v4 00/12] security: x86/sgx: SGX vs. LSM
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190705160549.tzsck5ho5kvtdhit@linux.intel.com>
 <20190708172930.GA20791@linux.intel.com>
 <20190709162203.gzyvulah5u7eksip@linux.intel.com>
 <20190709170917.GD25369@linux.intel.com>
 <20190710221638.bwnwtcozpv44ojdg@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <38d3b0ee-be9c-cb1a-785a-325a3ade003b@intel.com>
Date:   Wed, 10 Jul 2019 16:16:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710221638.bwnwtcozpv44ojdg@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/10/2019 3:16 PM, Jarkko Sakkinen wrote:
> Just some questions on these.
> 
> On Tue, Jul 09, 2019 at 10:09:17AM -0700, Sean Christopherson wrote:
>>    - FILE__ENCLAVE_EXECUTE: equivalent to FILE__EXECUTE, required to gain X
>>                             on an enclave page loaded from a regular file
> 
> One thing that I have hard time to perceive is that whether the process
> or the target object has them. So would this be in the files extended
> attribute or does process need to possess this or both?

The target object.

>>    - PROCESS2__ENCLAVE_EXECDIRTY: hybrid of EXECMOD and EXECUTE+WRITE,
>>                                   required to gain W->X on an enclave page
> 
> Still puzzling with EXECMOD given that how it is documented in
> https://selinuxproject.org/page/ObjectClassesPerms. If anything in that
> document is out of date, would be nice if it was updated.

If you search for "EXECMOD" in security/selinux/hooks.c in the latest 
(Linux-5.2) master, you'll find only one occurrence - at line 3702.

The logic over there, if translated into English, basically says 
FILE__EXECMOD is required (on the backing file) if mprotect() is called 
to request X on a private file mapping that has been modified by the 
calling process. That's what Sean meant by "W->X".

EXCLAVE_EXECDIRTY is similar to EXECMOD but because of his "maximal 
protection" model, LSM couldn't distinguish between "W->X" and "X->W", 
hence those two are collapsed into a single case - WX in "maximal 
protection".

>>    - PROCESS2__ENCLAVE_EXECANON: subset of EXECMEM, required to gain X on
>>                                  an enclave page that is loaded from an
>>                                  anonymous mapping
>>
>>    - PROCESS2__ENCLAVE_MAPWX: subset of EXECMEM, required to gain WX on an
>>                               enclave page
> 
> I guess these three belong to the process and are not attached to file.

Correct.

ENCLAVE_EXECANON basically means the calling process doesn't care what 
permissions given to enclave pages as the SIGSTRUCT alone is considered 
sufficient validation. This has a security impact process wide so shall 
be a process permission.

ENCLAVE_{EXECDIRTY|MAPWX} express enclave specific 
requirements/behaviors and IMO shall be enclave permissions, probably 
manifested as file permissions on the file containing SIGSTRUCT. Sean 
was taking a shortcut to make them process scope in order to avoid 
keeping the SIGSTRUCT file around, which was what I criticized as 
"illogical".

> How in SELinux anyway process in the first place acquires any SELinux
> permissions? I guess getty or whatever login process can set its perms
> before setuid() et al somehow (I don't know how) because they run as
> root?
> 
> /Jarkko
> 
