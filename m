Return-Path: <SRS0=nxNq=UC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 879C2C04AB5
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 18:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51B3326A32
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 18:39:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="qjcb5iWJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbfFCSjF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Jun 2019 14:39:05 -0400
Received: from ucol19pa12.eemsg.mail.mil ([214.24.24.85]:19889 "EHLO
        UCOL19PA12.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfFCSjE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 3 Jun 2019 14:39:04 -0400
X-EEMSG-check-017: 24972983|UCOL19PA12_EEMSG_MP10.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.60,547,1549929600"; 
   d="scan'208";a="24972983"
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by UCOL19PA12.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 03 Jun 2019 18:38:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1559587135; x=1591123135;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=wU6Hyz+2a34azTq6srz6DRW2jQIaBM564Y0b8P74+aY=;
  b=qjcb5iWJzYhZPYiWEUCiEpN1nGqnB3ukt2uQ3aIeYAd+TQ0v/07kuO95
   YIed2mbsjsMOFobVkVEaeL9v6KP/4clC5vyMmgY4/+Tg5TiuLOLDUlkms
   So2/HQJ+viV879/vzf8rUvAyhKklMaQ5pGYg03FH6Qh+2RBiqwCwI/aJz
   lgIgA08X/cBtFC4K4uFjeeXhbQUnCwfiBu8Ec7HbyDtizrlJeDL17gvWu
   soLB15FKhzWOhH1kzBDJe7ofhmBLT3Q6V6Saq5h+Xc7pRyJh8AnnYfza1
   JE3LcyNqL5JtEykkXWrGwlR2N6CL5SZIZZzSRs43//sfbYHly4tImoE0a
   Q==;
X-IronPort-AV: E=Sophos;i="5.60,547,1549929600"; 
   d="scan'208";a="28493144"
IronPort-PHdr: =?us-ascii?q?9a23=3ARGr9tRWKY2pim9N63BJJm1TY6S/V8LGtZVwlr6?=
 =?us-ascii?q?E/grcLSJyIuqrYZhKPuKdThVPEFb/W9+hDw7KP9fy5ACpZusnK6SpYOLV3FD?=
 =?us-ascii?q?Y9wf0MmAIhBMPXQWbaF9XNKxIAIcJZSVV+9Gu6O0UGUOz3ZlnVv2HgpWVKQk?=
 =?us-ascii?q?a3OgV6PPn6FZDPhMqrye+y54fTYwJVjzahfL9+Nhq7oRjMusUMnIdvJKQ8xh?=
 =?us-ascii?q?TUrndWZehd2H9lK0+Ukxvg/Mm74YRt8z5Xu/Iv9s5AVbv1cqElRrFGDzooLn?=
 =?us-ascii?q?446tTzuRbMUQWA6H0cUn4LkhVTGAjK8Av6XpbqvSTksOd2xTSXMtf3TbAwXj?=
 =?us-ascii?q?Si8rtrRRr1gyoJKzI17GfagdFrgalFvByuuQBww4/MYIGUKvV+eL/dfcgHTm?=
 =?us-ascii?q?ZFR8pdSjBNDp+5Y4YJAeUBJ+JYpJTjqVUIoxW1GA2gCPrxxjJMg3P727Ax3e?=
 =?us-ascii?q?Y8HgHcxAEuAswAsHrUotv2OqkdX++6w6vUwjvMdP5WxTXw5ZLUfhw9r/yBX7?=
 =?us-ascii?q?R9etfRx0k1EAPFi02dp5H5PzyLzuQNs3aU7+x9Xuyyjm4osQVxojyxycYsl4?=
 =?us-ascii?q?LEgZkVxU3f9Shi3IY0JcG3SE58YdK+FptQrDuVO5F5QsMlXWFloSA3waAIt5?=
 =?us-ascii?q?68eSgF0pUnxxjHZvyEbYeI+BTjW/iVITtig3JlYr2/ihCv+kaj0u3xTtS43V?=
 =?us-ascii?q?lFoyZfktTAq2oB2wLc58SZUPdx40Gs0iuV2Q/J8OFLO0U0mLLeK54m37E/iI?=
 =?us-ascii?q?IesV/GHi/qgEX2i7KWdlk89uio9evnZrLmq4eAN4BukAH+M7kumtelDeQkMg?=
 =?us-ascii?q?kBQ2ib+eOm2L3l4UL5W6lFguczkqnYtJDWPcUbpqinDA9Jyosv9hmyAji83N?=
 =?us-ascii?q?kYgHULNkxJdR2Zg4TzJl3COPX4Au2+g1Sonjdr3ffGPrj5D5XWM3fDi6zsfa?=
 =?us-ascii?q?p96kFAyAozyspT55RPCr4bOv7zVUjxtMLAAh8jLwO02/rnCMl61o4GQmKAHL?=
 =?us-ascii?q?WWMKXIvV+K/O4gP+mMZJUUuDbmN/gl4ObujX8nll8HZqmp2p0XZWu5HvRgP0?=
 =?us-ascii?q?WWf37sjs0dHmcNuwo0VPbqh0GaUT5Pe3ayWLox5jMhB4K8DofDRYetjKaa3C?=
 =?us-ascii?q?ihHZ1WZWFGClaSHnfubIiEX/YMaCSPIs5uiDAEVL6hS5M/2hGqrgP1171nLu?=
 =?us-ascii?q?/M8C0CqZ3jzMR15/HUlRwq8Tx0Etid02aWQmF3gGwIXTk20757oUBnzVeDy6?=
 =?us-ascii?q?d4ieRCFdNP//NJThs6NZnEwuNmFd/9RxjBftaVR1q8TdSmADcxTt0qzt8PZU?=
 =?us-ascii?q?Z9B8utjhTZ0yW2BL8VkqSBBIYo/aLEw3jxO8F9xm7E1KkkiFkmWNFPNWy9hq?=
 =?us-ascii?q?Nk8QjcHYvJnFuYl6qwcqQcxiHN/n+ZzWWSpEFYTBJwUaLdUHAEeETWt9v56V?=
 =?us-ascii?q?3ZQr+uE7snNg9ByM6EKqdQdtLpilBGTu/5ONvCe2Kxh3uwBRGQy7OIbYrqfX?=
 =?us-ascii?q?gd3SrEBEgfjQ8c4WuGNRI/Bie9o2PSFTluFVXybEPx9elxtmi2TlE7zw6UdU?=
 =?us-ascii?q?1tzbm19QAPhfyaVfwT2qgIuCA7qzV7BFy9xc7ZC8Kcpwp9e6VRecs9701a1W?=
 =?us-ascii?q?LdrAF9JoavL71mhlIHdgR3uETu1w9pBYlajccqq3YqxhJoKa2EyFNBay+Y3Z?=
 =?us-ascii?q?foN7LJMmn95gqva6/N2lzFyNaZ4L0P6PUjq1X7uAGmDFYt/Gt939lSyXuc6Y?=
 =?us-ascii?q?3ADBAOXpLpTkY36x96qqnBYiYj44PU1HtsMbS7szLZxdIpC/Uqygy6c9dcLq?=
 =?us-ascii?q?yEDgnyHNMeB8S0L+wqgVepZAoePO9O7K40I9+md/ye1a6pIulggDKmjX5A4I?=
 =?us-ascii?q?1m3EKM8DB8SvLS0JYDwvGZ0RGLWCv7jFekqsr3g5xLZSkOHmqjzijpHJNeab?=
 =?us-ascii?q?dsfYkVE2uuI9e4xtNlh5HzXX5V71+jB1Ua2MC3fRqedUDy3QpV1U4Pu3yohT?=
 =?us-ascii?q?O4zyBokzEutqefwCPOw+DtdRccPm5LRW9ijUrwIYiuiNAaWkmobgczmBS4+0?=
 =?us-ascii?q?nw37Jbq7hnL2nPXUdIeDD7L31lUquqqLqNecpP544zsShMVOS8YFaaSqPyoh?=
 =?us-ascii?q?cD3SPjGHZexDYmeD6wppX5nht6iGSHIHZ0tnrZdtl6xQ3D69zEWf5Rwj0GST?=
 =?us-ascii?q?F8iTnWAFi8Itao8cyXl5jdqOC+UXyuVplIfCn1woOPqjG76XdpARKhhfCznM?=
 =?us-ascii?q?PoEQwg3S/8zdlqWj3CrAzgbYnzy6S6LeVnc1FnBVL/6sd3AYJ+nZUqhJEWx3?=
 =?us-ascii?q?cago+Z/X0dkWf8Kd9bw77xbGIRRT4XxN7Y+Azl2ExlLnKUyIP1T26dwsRuZt?=
 =?us-ascii?q?ShfGMW1Twy79pQBKeX8rNEhy11rUS8rQ7LZvh9hDgdw+M06HEGm+EJpBYtzi?=
 =?us-ascii?q?KFD78IHklYJSnsmg+M79C/qqVXeWmufaG+1Ep5gNChCqyNrRtAWHb4fZciGz?=
 =?us-ascii?q?V87sJlMFLDyHfz8J3reMHMbdIPsR2ZixHAj+hSKJIrk/oFnyxnNHnnvXI71u?=
 =?us-ascii?q?E7jQZh3Y2gsIebLGVt+bqzAgREOT3te8MT5jbtgL5YnsaO2oCgAoluFS8PXJ?=
 =?us-ascii?q?vsUPKoFSkfte75OAmTED0zsGubFaDDEg+Y7Udst2jPHIyzN3GLOHkZys1vRA?=
 =?us-ascii?q?KDK0xFjwAbQi82kYQ5FwCt2czhdlx05jEX5l7ktBRMzvhkOAX4UmfavA2ocC?=
 =?us-ascii?q?s7SICDLBpK6QFP/1zVMcyE4eNzBS1Y/YeurBCMK2CCZgVHF2QJWk2eB134P7?=
 =?us-ascii?q?mu48XA/PacBuakM/TOZrCOo/REV/iU3ZKvzpdm/zGUO8WPJHZiDuE71VBEXX?=
 =?us-ascii?q?xjG8TZhi8ASyoYly/Wbs6bogu89TNzrsyl7PvrXwfv75OVC7ROKdVv5wy2ga?=
 =?us-ascii?q?CbOuGKgiZ2NCxY1pIMxHPS07gf3EAdiz9yeDmtD7sAsy3NTKXLl69TDh4bbT?=
 =?us-ascii?q?5zNcRS46I92AlNJdDUitfv2rFkif41Dk9PVUb9lcGxecwKP2a9OUvEBEmRNb?=
 =?us-ascii?q?SKPybLw9/tbqO8T71dl+RUtxusuTmFF0/vJCiMlz7sVxq3K+FDkDmbPABCuI?=
 =?us-ascii?q?G6ahtiEnDjQcn8ZR2/Md94kzs2zL4uinzXK2EWKSJ8fF9Vrr2M8SNYhe1yG2?=
 =?us-ascii?q?5G7np+LemJgCSZ7+7DKpYWrftrGCV0l/pe4Hsk17tV8DtIRPtvmCvdttRuuU?=
 =?us-ascii?q?2pkvGTyjp7VxpDsjVLi5iKvUl4OaXZ64NPWXDL/B8W7GWQDQgKqMVhCtH1p6?=
 =?us-ascii?q?9Qzd3PnrrpKDhe69LU4dccB8/MJcKdMXouLxzpGCLWDAQbVj6mLm7fh0takP?=
 =?us-ascii?q?Gd8n2asII2pYTrmJoLUrVbTkA6FusGCkR5G9wPOJl2XjIgkb6fjc4H/3++oA?=
 =?us-ascii?q?PNS8lApJDHUemdDuv1KDaFlrlJfBoIwbXkLYsNMo33wVBtal5/nI7SAUrfQc?=
 =?us-ascii?q?hNojF9bg8zuEhN6Hh+Tmw320LkcgOh+mQcGeSonh4siwtxffgi+y337lc2IF?=
 =?us-ascii?q?rKuDU/kE0rldr5hjCRdW25EKDlZoxfDWLft1IwKY/8WwZ4dxa1mwQwLzrNQf?=
 =?us-ascii?q?RTybBgb2FwlAjEuZZVAvlaZaxCfBIUg/qQYqN7/05br3Cc2UJf5ebDQaBnnQ?=
 =?us-ascii?q?8ufI/k+2lMwCp/fdU1IurWP6MPwV9O0PHd9hS03/w8lVdNb30G93mfLWtR4h?=
 =?us-ascii?q?0F?=
X-IPAS-Result: =?us-ascii?q?A2CKAQDZaPVc/wHyM5BcChsBAQEBAwEBAQcDAQEBgWWBZ?=
 =?us-ascii?q?ypqUTMohBSTWQIGgTWJUJEICQEBAQEBAQEBAS0HAQIBAYRAAoMSIzgTAQMBA?=
 =?us-ascii?q?QEEAQEBAQMBAWwcDII6KQGCZgEBAQECASMEEUEQCxgCAiYCAlcGDQYCAQGCX?=
 =?us-ascii?q?z8BgXYFDw+pLX4zhUeDJYFABoEMKItaF3iBB4E4gms+gmEEgTQLAQGDKIJYB?=
 =?us-ascii?q?IspgkCGCZQdagmCD4IYhCeMbQYbgiKKc4lZLY18hWKRISGBWCsIAhgIIQ+DJ?=
 =?us-ascii?q?4sThVsjAzABAYEEAQGNag8XA4IpAQE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 03 Jun 2019 18:38:37 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x53IcVxF024874;
        Mon, 3 Jun 2019 14:38:32 -0400
Subject: Re: [RFC PATCH 8/9] LSM: x86/sgx: Introduce ->enclave_load() hook for
 Intel SGX
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Cedric Xing <cedric.xing@intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Haitao Huang <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai Huang <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        William Roberts <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-9-sean.j.christopherson@intel.com>
 <d9ef6314-de91-ddcb-3d18-8155cd37e7be@tycho.nsa.gov>
 <20190603144251.GB13384@linux.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <7fa39363-78ec-8bd3-50e3-b5d05cd4593c@tycho.nsa.gov>
Date:   Mon, 3 Jun 2019 14:38:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190603144251.GB13384@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/3/19 10:42 AM, Sean Christopherson wrote:
> On Mon, Jun 03, 2019 at 10:19:18AM -0400, Stephen Smalley wrote:
>> On 5/31/19 7:31 PM, Sean Christopherson wrote:
>>> enclave_load() is roughly analogous to the existing file_mprotect().
>>>
>>> Due to the nature of SGX and its Enclave Page Cache (EPC), all enclave
>>> VMAs are backed by a single file, i.e. /dev/sgx/enclave, that must be
>>> MAP_SHARED.  Furthermore, all enclaves need read, write and execute
>>> VMAs.  As a result, file_mprotect() does not provide any meaningful
>>> security for enclaves since an LSM can only deny/grant access to the
>>> EPC as a whole.
>>>
>>> security_enclave_load() is called when SGX is first loading an enclave
>>> page, i.e. copying a page from normal memory into the EPC.  The notable
>>> difference from file_mprotect() is the allowed_prot parameter, which
>>> is essentially an SGX-specific version of a VMA's MAY_{READ,WRITE,EXEC}
>>> flags.  The purpose of allowed_prot is to enable checks such as
>>> SELinux's FILE__EXECMOD permission without having to track and update
>>> VMAs across multiple mm structs, i.e. SGX can ensure userspace doesn't
>>> overstep its bounds simply by restricting an enclave VMA's protections
>>> by vetting what is maximally allowed during build time.
>>>
>>> An alternative to the allowed_prot approach would be to use an enclave's
>>> SIGSTRUCT (a smallish structure that can uniquely identify an enclave)
>>> as a proxy for the enclave.  For example, SGX could take and hold a
>>> reference to the file containing the SIGSTRUCT (if it's in a file) and
>>> call security_enclave_load() during mprotect().  While the SIGSTRUCT
>>> approach would provide better precision, the actual value added was
>>> deemed to be negligible.  On the other hand, pinning a file for the
>>> lifetime of the enclave is ugly, and essentially caching LSM policies
>>> in each page's allowed_prot avoids having to make an extra LSM upcall
>>> during mprotect().
>>>
>>> Note, extensive discussion yielded no sane alternative to some form of
>>> SGX specific LSM hook[1].
>>>
>>> [1] https://lkml.kernel.org/r/CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com
>>>
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> ---
>>>   arch/x86/kernel/cpu/sgx/driver/ioctl.c | 14 +++++++++-----
>>>   include/linux/lsm_hooks.h              | 16 ++++++++++++++++
>>>   include/linux/security.h               |  2 ++
>>>   security/security.c                    |  8 ++++++++
>>>   4 files changed, 35 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
>>> index 5f71be7cbb01..260417ecbcff 100644
>>> --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
>>> +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
>>> @@ -8,6 +8,7 @@
>>>   #include <linux/highmem.h>
>>>   #include <linux/ratelimit.h>
>>>   #include <linux/sched/signal.h>
>>> +#include <linux/security.h>
>>>   #include <linux/shmem_fs.h>
>>>   #include <linux/slab.h>
>>>   #include <linux/suspend.h>
>>> @@ -580,21 +581,24 @@ static int sgx_encl_page_protect(unsigned long src, unsigned long prot,
>>>   				 unsigned long *allowed_prot)
>>>   {
>>>   	struct vm_area_struct *vma;
>>> +	int ret = 0;
>>> -	if (!(*allowed_prot & VM_EXEC))
>>> +	if (!(*allowed_prot & VM_EXEC) && !IS_ENABLED(CONFIG_SECURITY))
>>>   		goto do_check;
>>>   	down_read(&current->mm->mmap_sem);
>>>   	vma = find_vma(current->mm, src);
>>>   	if (!vma || (vma->vm_file && path_noexec(&vma->vm_file->f_path)))
>>>   		*allowed_prot &= ~VM_EXEC;
>>> +#ifdef CONFIG_SECURITY
>>> +	ret = security_enclave_load(vma, prot, allowed_prot);
>>> +#endif
>>
>> Normally you'd define a static inline stub for the hook in the #else clause
>> for CONFIG_SECURITY in include/linux/security.h and avoid any ifdef here.
> 
> Ah, right.
>   
>> What ensures that the mapping referenced by src can't be changed to an
>> entirely different one (with a different vm_file) between the time of check
>> (here) and the time of use?
> 
> Nothing.  Holding mmap_sem across copy_from_user() would suffice, correct?

I don't believe you can do that; copy_from_user() could stall 
indefinitely.  Not sure how to do what you want here or if it requires 
changing the interface.

> 
>>>   	up_read(&current->mm->mmap_sem);
>>>   do_check:
>>> -	if (prot & ~*allowed_prot)
>>> -		return -EACCES;
>>> -
>>> -	return 0;
>>> +	if (!ret && (prot & ~*allowed_prot))
>>> +		ret = -EACCES;
>>> +	return ret;
>>>   }
>>>   static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,

