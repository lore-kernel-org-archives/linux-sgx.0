Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C95C433FE
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Oct 2022 13:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiJKN5O (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Oct 2022 09:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiJKN5O (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 11 Oct 2022 09:57:14 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABD98C003
        for <linux-sgx@vger.kernel.org>; Tue, 11 Oct 2022 06:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665496633; x=1697032633;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9TFtGT2GGwaUOYlsBWTOv+5WyJAp+OzSddO2qrRoROg=;
  b=Ebx8wcE6rYDBe4XMkuzP6rF7ilsDRQFgMkBOcf/L/j4dxik86azhTOqy
   lJHYZ4MOrwRhrqxLQPWAtRQZ+emNKXbT2NSafjkKXHnNRL/RI2q20TLVh
   CMi1/o0LOwCGIT+13dx8BX+2CZjYY4axhzjkEG0+b25aEYnwduMHVfnX3
   GjrFhFD5+HtNGkvrEO13wJ7IhnH2xc0wF+G6LwcS5SRYA38bwCrrcoolo
   6w03r7FpCDfoePLb015et22ZTHjt7lKzxSIG1mSHMVN9omRhwca+GHJLV
   3nMMisTBQDkdxYm4NJr62ft0lftEV0+regrShgTTFdlDqGIm1XlJM6HZe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="366499070"
X-IronPort-AV: E=Sophos;i="5.95,176,1661842800"; 
   d="scan'208";a="366499070"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 06:57:12 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="955343693"
X-IronPort-AV: E=Sophos;i="5.95,176,1661842800"; 
   d="scan'208";a="955343693"
Received: from makozuch-mobl2.amr.corp.intel.com (HELO [10.209.39.67]) ([10.209.39.67])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 06:57:09 -0700
Message-ID: <277c494c-7e55-2d73-dbf3-7a841836a395@intel.com>
Date:   Tue, 11 Oct 2022 06:57:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v9 2/3] x86/sgx: Introduce union with vepc_vaddr field for
 virtualization case
Content-Language: en-US
To:     Zhiquan Li <zhiquan1.li@intel.com>, linux-sgx@vger.kernel.org,
        tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, kai.huang@intel.com
Cc:     seanjc@google.com, fan.du@intel.com, cathy.zhang@intel.com,
        tglx@linutronix.de, bp@suse.de
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
 <20220920063948.3556917-3-zhiquan1.li@intel.com>
 <f6180914-2b63-29dd-8dc3-de48c4197769@intel.com>
 <540df1d4-d784-b33e-e1e3-573aa5f804c6@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <540df1d4-d784-b33e-e1e3-573aa5f804c6@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 10/10/22 22:49, Zhiquan Li wrote:
> 
> May I add below description to explain behavior changes in changelog?
> 
> The behavior is changed when allocating an EPC page to a virtual EPC,
> the virtual address of the virtual EPC will be passed as the first
> argument of sgx_alloc_epc_page() which be assigned to 'encl_owner' field
> of struct sgx_epc_page.  After that, the reversed relationship from an
> EPC page to virtual EPC doesn't exist, in practice, such relationship is
> useless.

That honestly doesn't help me understand what's going on here.

The changelog and subject are spending far too much time explaining the
low level details of what is being done (like "add a union") and far too
little time explaining what it _means_.

