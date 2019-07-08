Return-Path: <SRS0=W/oj=VF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE4DC606C6
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 17:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C38632189F
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 17:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbfGHRuA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Jul 2019 13:50:00 -0400
Received: from mga12.intel.com ([192.55.52.136]:30625 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390638AbfGHRt7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 8 Jul 2019 13:49:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 10:49:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,466,1557212400"; 
   d="scan'208";a="316780227"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by orsmga004.jf.intel.com with ESMTP; 08 Jul 2019 10:49:58 -0700
Subject: Re: [RFC PATCH v3 0/4] security/x86/sgx: SGX specific LSM hooks
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, casey.schaufler@intel.com,
        jmorris@namei.org, luto@kernel.org, jethro@fortanix.com,
        greg@enjellic.com, sds@tycho.nsa.gov,
        jarkko.sakkinen@linux.intel.com
References: <cover.1561588012.git.cedric.xing@intel.com>
 <cover.1562542383.git.cedric.xing@intel.com>
 <20190708155524.GD20433@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <8ba6c32d-cedc-53fd-9e86-f78be0067ac3@intel.com>
Date:   Mon, 8 Jul 2019 10:49:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708155524.GD20433@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/8/2019 8:55 AM, Sean Christopherson wrote:
> On Sun, Jul 07, 2019 at 04:41:30PM -0700, Cedric Xing wrote:
> ...
> 
>> different FSMs to govern page protection transitions. Implementation wise, his
>> model also imposes unwanted restrictions specifically to SGX2, such as:
>>    · Complicated/Restricted UAPI – Enclave loaders are required to provide
> 
> I don't think "complicated" is a fair assessment.  For SGX1 enclaves it's
> literally a direct propagation of the SECINFO RWX flags.

True only for SGX1.
>>      “maximal protection” at page load time, but such information is NOT always
>>      available. For example, Graphene containers may run different applications
>>      comprised of different set of executables and/or shared objects. Some of
>>      them may contain self-modifying code (or text relocation) while others
>>      don’t. The generic enclave loader usually doesn’t have such information so
>>      wouldn’t be able to provide it ahead of time.
> 
> I'm unconvinced that it would be remotely difficult to teach an enclave
> loader that an enclave or hosted application employs SMC, relocation or
> any other behavior that would require declaring RWX on all pages.

You've been talking as if "enclave loader" is tailored to the enclave it 
is loading. But in reality "enclave loader" is usually a library knowing 
usually nothing about the enclave. How could it know if an enclave 
contains self-modifying code?

>>    · Inefficient Auditing – Audit logs are supposed to help system
>>      administrators to determine the set of minimally needed permissions and to
>>      detect abnormal behaviors. But consider the “maximal protection” model, if
>>      “maximal protection” is set to be too permissive, then audit log wouldn’t
>>      be able to detect anomalies;
> 
> Huh?  Declaring overly permissive protections is only problematic if an
> LSM denies the permission, in which case it will generate an accurate
> audit log.
> 
> If the enclave/loader "requires" a permission it doesn't actually need,
> e.g. EXECDIRTY, then it's a software bug that should be fixed.  I don't
> see how this scenario is any different than an application that uses
> assembly code without 'noexecstack' and inadvertantly "requires"
> EXECSTACK due to triggering "read implies exec".  In both cases the
> denied permission is unnecessary due to a userspace application bug.

You see, you've been assuming "enclave loader" knows everything and 
tailored to what it loads in a particular application. But the reality 
is the loader is generic and probably shared by multiple applications. 
It needs some generic way to figure out the "maximal protection". An 
implementation could use information embedded in the enclave file, or 
could just be "configurable". In the former case, you put extra burdens 
on the build tools, while in the latter case, your audit logs cannot 
help generating an appropriate configuration.

>>      or if “maximal protection” is too restrictive,
>>      then audit log cannot identify the file violating the policy.
> 
> Maximal protections that are too restrictive are completely orthogonal to
> LSMs as the enclave would fail to run irrespective of LSMs.  This is no
> different than specifying the wrong RWX flags in SECINFO, or opening a
> file as RO instead of RW.

Say loader is configurable. By looking at the log, can an administrator 
tell which file has too restrictive "maximal protection"?

>> In either case the audit log cannot fulfill its purposes.
>>    · Inability to support #PF driven EPC allocation in SGX2 – For those
>>      unfamiliar with SGX2 software flows, an SGX2 enclave requests a page by
>>      issuing EACCEPT on the address that a new page is wanted, and the resulted
>>      #PF is expected to be handled by the kernel by EAUG’ing an EPC page at the
>>      fault address, and then the enclave would be resumed and the faulting
>>      EACCEPT retried, and succeed. The key requirement is to allow mmap()’ing
>>      non-existing enclave pages so that the SGX module/subsystem could respond
>>      to #PFs by EAUG’ing new pages. Sean’s implementation doesn’t allow
>>      mmap()’ing non-existing pages for variety of reasons and therefore blocks
>>      this major SGX2 usage.
> 
> This is simply wrong.  The key requirement in the theoretical EAUG scheme
> is to mmap() pages that have not been added to the _hardware_ maintained
> enclave.  The pages (or some optimized representation of a range of pages)
> would exist in the kernel's software mode of the enclave.

You are right. Code can always change. My assessment was made on what's 
in your patch.

The key point here is your patch is more complicated than it seems 
because you've been hand-waving on imminent requirements.
