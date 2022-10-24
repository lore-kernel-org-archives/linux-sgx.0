Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7AA9ECAAA1
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Oct 2022 16:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbiJXQgN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 24 Oct 2022 12:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbiJXQf5 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 24 Oct 2022 12:35:57 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14ACC099C
        for <linux-sgx@vger.kernel.org>; Mon, 24 Oct 2022 08:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666624984; x=1698160984;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=XHaxASxoW6yfDLhXdhzfrGcb6lNNgoBghg0XM5l09GA=;
  b=QVFGx15ymghlaMSCBgVCc1L0ZqdRb2Do7lVcfhRyKRm9bCiurkDUYJms
   35vxBEhoY9zTNR2/AcWBqAn3T63sSdYYVxD/vtzs+thh23Jmd+8Yqfz2A
   J5U+Jv1qCSHvgpeO5I3AJBhV1qgO/LUe7opj4bj/pziBGkOKDN6zvxwSJ
   UxG3cd7QOnBHPaAa97UxtQWI5ATMtKJLhgTstL1TWo+R05Rdk+4UMYgHH
   ArDxqZAI+uLJd5CqvkW71xi/AmVStmE33h8au8BBmrGpSxc6pyJxxaw8J
   ind2/scowBYHDlyIzTFXDTdWCu51AxWmkbSRvPi9jeM6WGXu0croFirxD
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="334032593"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="334032593"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 08:17:58 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="700195265"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="700195265"
Received: from hhuan26-mobl1.amr.corp.intel.com ([10.122.136.245])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 24 Oct 2022 08:17:57 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Jarkko Sakkinen" <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        reinette.chatre@intel.com, vijay.dhanraj@intel.com
Subject: Re: [RFC PATCH 2/4] x86/sgx: Implement support for MADV_WILLNEED
References: <20221019191413.48752-1-haitao.huang@linux.intel.com>
 <20221019191413.48752-2-haitao.huang@linux.intel.com>
 <20221019191413.48752-3-haitao.huang@linux.intel.com>
 <Y1Ww0vEHcQDitaYJ@kernel.org>
Date:   Mon, 24 Oct 2022 10:14:03 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.1ujtxux7wjvjmi@hhuan26-mobl1.amr.corp.intel.com>
In-Reply-To: <Y1Ww0vEHcQDitaYJ@kernel.org>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko,

On Sun, 23 Oct 2022 16:23:30 -0500, Jarkko Sakkinen <jarkko@kernel.org>  
wrote:
...
>> +	/* Here: vm_start <= pos < end <= vm_end */
>> +	while (pos < end) {
>> +		if (xa_load(&encl->page_array, PFN_DOWN(pos)))
>> +			continue;
>> +		if (signal_pending(current)) {
>> +			if (pos == start)
>> +				ret = -ERESTARTSYS;
>> +			else
>> +				ret = -EINTR;
>> +			goto unlock;
>> +		}
>> +		ret = sgx_encl_eaug_page(vma, encl, pos);
>
> You should instead just do the export in the previous commit,
> and convert the return values here. Less pollution to the
> existing code base.
>

Thanks for the feedback. Just to clarify, you prefer following:

1. do export only in separate patch, no return type and value change
2. change return type and value in this patch.

Note the sgx_fadvise function needs to stop EAUGing and return in case of  
-EBUSY. So sgx_encl_eaug_page has to return error code -EBUSY separately,  
instead of lumping -EBUSY with VM_FAULT_NOPAGE which was fine for page  
fault handler.

Thanks
Haitao
