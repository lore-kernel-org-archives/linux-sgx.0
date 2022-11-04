Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B30C433FE
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Nov 2022 16:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiKDQex (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Nov 2022 12:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbiKDQew (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 4 Nov 2022 12:34:52 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E4627148
        for <linux-sgx@vger.kernel.org>; Fri,  4 Nov 2022 09:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667579692; x=1699115692;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tagZUpRIUwStZaAHzI/2dFUl0GpHkbCaKpWnnDZVu7s=;
  b=UKSsR+HLO1uzUQqHb/plXJ32gfH44aknEDQQaOtGrOCiJIhmAwQCxhCP
   OrYMavJLfBd/QFurv98edXOfdOf/2us1gLzS1hNxH8yvHyK8XMqfhzEoF
   z8TxmjOD+6PBOTAqgV19B1LkN3kVH84VBBYspTeN5DqJe1FK6LcbulH6o
   SWykJb9N8d9Bceyv5WB9EgjthG+mIBF7t+BlhQ029CHnU03qJmH7xDg+y
   CaAkXeJf3IYchihF4hHS+uMcsWSjjtP9QxPfFXibMTEXiPAocevNUJmm5
   StbOaZuvIN4GEmTgFMcGMS7La5yI2QtioNqB0lk9MjMp/y2YJmZjX/FU1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="372119016"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="372119016"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 09:34:51 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="698708178"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="698708178"
Received: from anantsin-mobl2.amr.corp.intel.com (HELO [10.209.97.57]) ([10.209.97.57])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 09:34:50 -0700
Message-ID: <076291f2-4bff-e1ac-e590-74b94b5c03ef@intel.com>
Date:   Fri, 4 Nov 2022 09:34:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@suse.de" <bp@suse.de>, "Zhang, Cathy" <cathy.zhang@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>, "Du, Fan" <fan.du@intel.com>
References: <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
 <4930999a-888f-88bc-a05c-86762504f059@intel.com>
 <c8e7cff6f8d66ce4f8575caaf69f02b491ed7d90.camel@intel.com>
 <5afff147-dfb4-9033-6826-5965ba0bf3a0@intel.com>
 <061580727e503d092ca3867919fa0f26391568eb.camel@intel.com>
 <10c4b928a37fdf96df767fc7b8f1348f6af05984.camel@intel.com>
 <Y1WmZgqIkl8GkR/i@kernel.org>
 <e8f1e391-0362-33b7-aaf6-45a685eba0a4@intel.com>
 <Y2BsSCM1BWlsqPcK@kernel.org>
 <65924f603f88462eae6edd5ecb9f56aec1be1864.camel@intel.com>
 <Y2U9JJUBFiscIidn@google.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y2U9JJUBFiscIidn@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 11/4/22 09:26, Sean Christopherson wrote:
>> I've been re-thinking about this #MC handle on virtual EPC by stepping back to
>> the beginning, and I think we have more problems than this "whether kernel
>> should enforce child cannot mmap() virtual EPC".
> IMO, virtual EPC should be restricted to a single mm_struct, which is what was
> originally proposed many years ago[*].  I should have pushed back harder, but by
> that point I had mostly stopped caring about SGX.

Considering that we have VM_DONTCOPY set on the vepc VMA, this shouldn't
be too hard to pull off.  We could just return -EBUSY if another mm
comes around and tries to mmap() the fd.
