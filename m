Return-Path: <SRS0=jkgx=6V=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F24CC38A24
	for <linux-sgx@archiver.kernel.org>; Thu,  7 May 2020 05:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E733E208DB
	for <linux-sgx@archiver.kernel.org>; Thu,  7 May 2020 05:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbgEGFCx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 7 May 2020 01:02:53 -0400
Received: from mga05.intel.com ([192.55.52.43]:59002 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgEGFCx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 7 May 2020 01:02:53 -0400
IronPort-SDR: h8az6S7szrE8Xb62WyJrk2us2rYL+/KGJiblkjevAnjGjQQW31yzhWNu6qLBKFT5xoVbbq/XN5
 2K4CaTTB35Gw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 22:02:52 -0700
IronPort-SDR: stdfQH4ZVMo6zVmW4SopcSsgg9s+guoo41EqFH2xpkk9fsSUyXe6bTjGfQ3X9Y60kFGVdXTnzn
 T+ZnPo2Dxe0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,362,1583222400"; 
   d="scan'208";a="462020755"
Received: from hhuan26-mobl1.amr.corp.intel.com ([10.213.160.47])
  by fmsmga006.fm.intel.com with ESMTP; 06 May 2020 22:02:51 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Nathaniel McCallum" <npmccallum@redhat.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>
Cc:     "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, "Neil Horman" <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        "Josh Triplett" <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, "David Rientjes" <rientjes@google.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        "Patrick Uiterwijk" <puiterwijk@redhat.com>
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <CAOASepPFe_ucuwe7JW_-+VBQ4=+sHqyGXOdA9kUbcYA_9=v0sA@mail.gmail.com>
 <20200506221422.GK3329@linux.intel.com>
Date:   Thu, 07 May 2020 00:02:50 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0j8dm0zzwjvjmi@hhuan26-mobl1.amr.corp.intel.com>
In-Reply-To: <20200506221422.GK3329@linux.intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 06 May 2020 17:14:22 -0500, Sean Christopherson  
<sean.j.christopherson@intel.com> wrote:

> On Wed, May 06, 2020 at 05:42:42PM -0400, Nathaniel McCallum wrote:
>> Tested on Enarx. This requires a patch[0] for v29 support.
>>
>> Tested-by: Nathaniel McCallum <npmccallum@redhat.com>
>>
>> However, we did uncover a small usability issue. See below.
>>
>> [0]:  
>> https://github.com/enarx/enarx/pull/507/commits/80da2352aba46aa7bc6b4d1fccf20fe1bda58662
>
> ...
>
>> > * Disallow mmap(PROT_NONE) from /dev/sgx. Any mapping (e.g.  
>> anonymous) can
>> >   be used to reserve the address range. Now /dev/sgx supports only  
>> opaque
>> >   mappings to the (initialized) enclave data.
>>
>> The statement "Any mapping..." isn't actually true.
>>
>> Enarx creates a large enclave (currently 64GiB). This worked when we
>> created a file-backed mapping on /dev/sgx/enclave. However, switching
>> to an anonymous mapping fails with ENOMEM. We suspect this is because
>> the kernel attempts to allocate all the pages and zero them but there
>> is insufficient RAM available. We currently work around this by
>> creating a shared mapping on /dev/zero.
>
> Hmm, the kernel shouldn't actually allocate physical pages unless they're
> written.  I'll see if I can reproduce.
>

For larger size mmap, I think it requires enabling vm overcommit mode 1:
echo 1 | sudo tee /proc/sys/vm/overcommit_memory


>> If we want to keep this mmap() strategy, we probably don't want to
>> advise mmap(ANON) if it allocates all the memory for the enclave ahead
>> of time, even if it won't be used. This would be wasteful.
>>
>> OTOH, having to mmap("/dev/zero") seems a bit awkward.


-- 
Using Opera's mail client: http://www.opera.com/mail/
