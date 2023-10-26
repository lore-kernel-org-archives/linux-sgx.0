Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F44BC25B48
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Oct 2023 16:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbjJZQeY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 26 Oct 2023 12:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjJZQeX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 26 Oct 2023 12:34:23 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8C118A;
        Thu, 26 Oct 2023 09:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698338061; x=1729874061;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=jnQgMYyJfhLnAlaZW3gDaEF91wiW9ZrBuVYvIWcLdPU=;
  b=EG4K0sIeYSIPZIfWclvGZ3x5xuZh9dMsM+bSqTQlNVxFpTUv9Ekj+xeV
   jSdxCwvW31WbKYOXURDqsxNATYgL01wCEplzL87Jv37KvlJyvtJyHWtZx
   YiFZsIsD5fJL/qz9WqHcI9OH/PbC0Ctbcw/QBv5CCIjOgiZrzPa/xvyH/
   gn9ePK71Clj39TYMvV4bvNB9FCwGyEKAb/EEQSzW5vBE1LG2lxAeriIHU
   b4wdB6CBvMhUdFwb5/XwDx+G2Xvs7WxRSa/izoUxwTQdYZouc2y+5Ys5X
   hidaF/cjJK08JQhNoFqVYKKRVPFqE91y0y4fmG34gdfdLduNjXRUzn/vV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="389778"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="389778"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 09:34:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="1090642943"
X-IronPort-AV: E=Sophos;i="6.03,253,1694761200"; 
   d="scan'208";a="1090642943"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.93.50.175])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 26 Oct 2023 09:34:20 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Reinette Chatre" <reinette.chatre@intel.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Ingo Molnar" <mingo@kernel.org>
Subject: Re: [PATCH] x86/sgx: Return VM_FAULT_SIGBUS for EPC exhaustion
References: <20231020025353.29691-1-haitao.huang@linux.intel.com>
 <b8ec3061-436f-41d3-8bff-635a90774dfb@intel.com>
 <b389986bac0e65ce128c9553603436efdda24a58.camel@intel.com>
 <b709d680-5754-45ab-ae73-c812420f10e5@intel.com>
Date:   Thu, 26 Oct 2023 11:34:19 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.2dfkbh2iwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <b709d680-5754-45ab-ae73-c812420f10e5@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 26 Oct 2023 11:01:57 -0500, Reinette Chatre  
<reinette.chatre@intel.com> wrote:

>
>
> On 10/25/2023 4:58 PM, Huang, Kai wrote:
>> On Wed, 2023-10-25 at 07:31 -0700, Hansen, Dave wrote:
>>> On 10/19/23 19:53, Haitao Huang wrote:
>>>> In the EAUG on page fault path, VM_FAULT_OOM is returned when the
>>>> Enclave Page Cache (EPC) runs out. This may trigger unneeded OOM kill
>>>> that will not free any EPCs. Return VM_FAULT_SIGBUS instead.
>
> This commit message does not seem accurate to me. From what I can tell
> VM_FAULT_SIGBUS is indeed returned when EPC runs out. What is addressed
> with this patch is the error returned when kernel (not EPC) memory runs
> out.
>


Sorry I got it mixed up between sgx_alloc_epc_page and sgx_encl_page_alloc  
returns.
You are right. Please drop this patch.

Thanks
Haitao
