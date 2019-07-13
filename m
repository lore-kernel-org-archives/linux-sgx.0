Return-Path: <SRS0=72mU=VK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D78C31E40
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 17:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B31862064A
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 17:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbfGMRU7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Jul 2019 13:20:59 -0400
Received: from mga14.intel.com ([192.55.52.115]:18789 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727853AbfGMRU7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Jul 2019 13:20:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jul 2019 10:20:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,487,1557212400"; 
   d="scan'208";a="318288502"
Received: from bxing-mobl.amr.corp.intel.com (HELO [10.255.230.48]) ([10.255.230.48])
  by orsmga004.jf.intel.com with ESMTP; 13 Jul 2019 10:20:57 -0700
Subject: Re: [RFC PATCH v4 3/3] selftests/x86/sgx: Augment SGX selftest to
 test vDSO API
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, sean.j.christopherson@intel.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, kai.svahn@intel.com, kai.huang@intel.com
References: <cover.1563000446.git.cedric.xing@intel.com>
 <657fe13cbf962d72dc1afc0e25577d8e89225702.1563000446.git.cedric.xing@intel.com>
 <dddd9db0d2e7a4d4246ecbb096d0b35cd0aecb2a.camel@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <6e53cf41-fb2a-0a08-22d0-e6bef2708f82@intel.com>
Date:   Sat, 13 Jul 2019 10:20:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <dddd9db0d2e7a4d4246ecbb096d0b35cd0aecb2a.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/13/2019 8:21 AM, Jarkko Sakkinen wrote:
> On Fri, 2019-07-12 at 23:51 -0700, Cedric Xing wrote:
>> This patch augments SGX selftest with two new tests.
>>
>> The first test exercises the newly added callback interface, by marking the
>> whole enclave range as PROT_READ, then calling mprotect() upon #PFs to add
>> necessary PTE permissions per PFEC (#PF Error Code) until the enclave finishes.
>> This test also serves as an example to demonstrate the callback interface.
>>
>> The second test single-steps through __vdso_sgx_enter_enclave() to make sure
>> the call stack can be unwound at every instruction within that vDSO API. Its
>> purpose is to validate the hand-crafted CFI directives in the assembly.
>>
>> Besides the new tests, this patch also fixes minor problems in the Makefile,
>> such as:
>>    * appended "--build-id=none" to ld command line to suppress the
>>      ".note.gnu.build-id section discarded" linker warning.
>>    * removed "--remove-section=.got.plt" from objcopy command line as that
>>      section would never exist in statically linked (enclave) images.
>>
>> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
> 
> This is also in "unreviewable" state. And you ignored the comment about the
> function names.

Like I said, there are plenty of test### functions in the selftests. And 
your original version didn't have even a name - everything was inside 
main() without any comments. How was your original version "reviewable"?

> All I asked was patch that just changes the calling convention to send v21
> and include the vDSO change. How hard can that be?

Your selftest Makefile was broken. You had to run the test manually. It 
broke the build on 32-bit platforms.

> Also do not add the main LKML (linux-kernel@vger.kernel.org) to these patches
> that are not directly against the mainline. That is only causing unnecessary
> saturation and noise.

My apology for that. I'll take note.

> Thank you.
> 
> /Jarkko
> 
