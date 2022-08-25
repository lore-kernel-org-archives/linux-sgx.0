Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21043C64990
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Aug 2022 14:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236307AbiHYOHr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Aug 2022 10:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234323AbiHYOHq (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 25 Aug 2022 10:07:46 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6050171BF4;
        Thu, 25 Aug 2022 07:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661436465; x=1692972465;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GST8RRmfWAoiFI+QlmkJDVyOQRsd+QkD+I7knZPLyqA=;
  b=V2soXCRPu5I9nI29nG1c3Gn1z3hFS167iqG3HEvfEIhtMRYl51s8kT3W
   rzcwZz2xPN7oYLo9gDCHDx9o5vj3BXQ+/k38+vBP34KY3QmHVuDCOpP+u
   tmpNfW44kM3v03blr21sNbIy+dlibi7gf5po8x9Wp1IqsShlK6LthAQRM
   ZgwYfL9ac8z2yH/+Qn8MQonxrky8NBbDfksztIVPfEDsnP3Mh9goxn9X9
   omW2oiNk+BrzwuV4N124N/1ZA2/2MV49L32Go8xvZ68QrhRKlVm/SyRw6
   7nfCZZB+t241aToUCCXA2nAd3jY6ykCo7TwQBHyogCqkgp+ODQDY0xeJw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="281213757"
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="281213757"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 07:07:44 -0700
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="752494103"
Received: from rnaraya1-mobl1.amr.corp.intel.com (HELO [10.212.254.160]) ([10.212.254.160])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 07:07:44 -0700
Message-ID: <c63e554e-e433-b088-280c-aa1a185ade61@intel.com>
Date:   Thu, 25 Aug 2022 07:07:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3] x86/sgx: Do not consider unsanitized pages an error
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
References: <20220825080802.259528-1-jarkko@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220825080802.259528-1-jarkko@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 8/25/22 01:08, Jarkko Sakkinen wrote:
> However, if the SGX subsystem initialization is retracted, the sanitization
> process could end up in the middle, and sgx_dirty_page_list be left
> non-empty for legit reasons.

What does "retraction" mean in this context?
