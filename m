Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F05C4332F
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Oct 2022 23:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiJMX5v (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Oct 2022 19:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJMX5u (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 13 Oct 2022 19:57:50 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04295196095
        for <linux-sgx@vger.kernel.org>; Thu, 13 Oct 2022 16:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665705469; x=1697241469;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Vfsl+SCxG18IjDK0SHhkgm+nhNNTO6BR7Rn+1Cm8Ok0=;
  b=ClaJvFXxkev1y5+yp1xC+msUHeJawdR7CYHXYv+yHsCY88Ahy0lMV1Gu
   lbhDUByMZ+DgOeV6qeH03UOtPrTsQEDFvOhSJJ0Mph1ao9Mf9kMUyoA9A
   WTdfwwPJ8KX2y1PWGlkAHzn3uCgw2pCYyd5PUN3y1/in72zJisZvevUE3
   dHtgtykxjDnJlsadx7hBfWP0wA4eN2U2hSTsC+vQEoExewu3IcYFAXTmQ
   F1gKAw/Cb1MjyNODHmEiio16dUG5qaNDyPh4zBsJKFMVfy2VX8LD+rD5f
   j/eJhY/LBAM1IGChFLCn5C5uBrp/D1qLtqGJeShZglodC9vTHkr7Aw99K
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="303980200"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="303980200"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 16:57:49 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="732084196"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="732084196"
Received: from mkucejko-mobl.ger.corp.intel.com (HELO [10.213.24.166]) ([10.213.24.166])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 16:57:44 -0700
Message-ID: <5afff147-dfb4-9033-6826-5965ba0bf3a0@intel.com>
Date:   Thu, 13 Oct 2022 16:57:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Li, Zhiquan1" <zhiquan1.li@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "Du, Fan" <fan.du@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>, "bp@suse.de" <bp@suse.de>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
 <20220920063948.3556917-4-zhiquan1.li@intel.com>
 <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
 <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
 <f8b49a6b-44ce-9477-b2ba-39abadfbd68f@intel.com>
 <fb885d7f-388c-6a53-798b-06805fefca3d@intel.com>
 <fc9ed3e0-94f1-0bbc-06db-fd14d41b7c21@intel.com>
 <42470b9c41adefd2d4b4c79a3b7b2963cd24f423.camel@intel.com>
 <4f82ec46-4c85-babb-38ea-a6ecc5e397a9@intel.com>
 <5ade54ce8e182307309426e1055dcc580c1dc5fc.camel@intel.com>
 <4930999a-888f-88bc-a05c-86762504f059@intel.com>
 <c8e7cff6f8d66ce4f8575caaf69f02b491ed7d90.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <c8e7cff6f8d66ce4f8575caaf69f02b491ed7d90.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 10/13/22 16:40, Huang, Kai wrote:
> What's your suggestion?

I'm fresh out of suggestions.
