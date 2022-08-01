Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258D9C00144
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Aug 2022 18:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiHASEb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Aug 2022 14:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234390AbiHASEQ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 1 Aug 2022 14:04:16 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C73255A2
        for <linux-sgx@vger.kernel.org>; Mon,  1 Aug 2022 11:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659377037; x=1690913037;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=3hc0FvheO9x7tyJnNG0cEzdKBOqagS14Bn1F24eh+LA=;
  b=RdYB4loiC5DSFQs4L+LryP32uLhY96fx1AkwZee2VzKwyDPQ0KBHkX8M
   hZZVEXNgAWnN8j3UG4Y01euAcrtTd/8LNCqL4togdUjwjdVPfUqhTcesn
   IrPqoK+70+5bAZ924EL2zuBHKkIB5/Qr2ghZGCLAxcCF+I4ykPAgSpqMw
   TRJgKvOqC3UQE0ssqywEmkMLCHa6AZ5MkVaQOgirgsbcjcJPMaRqJ4IFg
   3AwixQqvd2trNNQYGYFczGnZb+jZ8HpZtMq3xuHoYEhHjJh4QxJ1zM4lv
   XU23fMvHizwPwPpi6S4IkQypvchZjBTD0lIpxSUQ/gfY6CquqhY4r2HIA
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="350919702"
X-IronPort-AV: E=Sophos;i="5.93,208,1654585200"; 
   d="scan'208";a="350919702"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 11:03:57 -0700
X-IronPort-AV: E=Sophos;i="5.93,208,1654585200"; 
   d="scan'208";a="605743369"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO hhuan26-mobl1.mshome.net) ([10.212.71.218])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 01 Aug 2022 11:03:55 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "Haitao Huang" <haitao.huang@linux.intel.com>
Cc:     "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: Support SGX2 V5: Seg-fault with EACCEPT for large number of EPC
 pages
References: <DM8PR11MB55912A7F47A84EC9913A6352F6999@DM8PR11MB5591.namprd11.prod.outlook.com> <1600d7b3-24c2-7455-4a7f-56366ccd03aa@intel.com> <DM8PR11MB55911E8F9DA739F215FD1D90F6999@DM8PR11MB5591.namprd11.prod.outlook.com> <op.1p214u15wjvjmi@hhuan26-mobl1.mshome.net>
Date:   Mon, 01 Aug 2022 13:00:26 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.1p8hm0gnwjvjmi@hhuan26-mobl1.mshome.net>
In-Reply-To: <op.1p214u15wjvjmi@hhuan26-mobl1.mshome.net>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 29 Jul 2022 14:37:32 -0500, Haitao Huang  
<haitao.huang@linux.intel.com> wrote:

> On Fri, 29 Jul 2022 14:14:15 -0500, Dhanraj, Vijay  
> <vijay.dhanraj@intel.com> wrote:
>
>> Hi Dave,
>>
>> Tried with the latest tip and I still observe the issue. I tried 2G, 4G  
>> and 8G sized requests and as before, 2GB size requests works fine but  
>> 4GB and 8GB requests failed.
>>
>> Commit I have applied my test patch:
>> commit 038ef9928e1acb37bbe808c23a421189f1fd96cb (origin/x86/sgx)
>> Merge: e0a5915f1cca e0dccc3b76fb
>> Author: Ingo Molnar <mingo@kernel.org>
>> Date:   Tue Jul 26 09:14:28 2022 +0200
>>
>>     Merge tag 'v5.19-rc8' into x86/sgx, to resolve conflicts
>>
>> Kernel version:
>> Linux sdp 5.19.0-rc8-custom #1 SMP PREEMPT_DYNAMIC Fri Jul 29 10:28:25  
>> PDT 2022 x86_64 x86_64 x86_64 GNU/Linux
>>
>
> Using a kernel built at the same commit, I did the same test on another  
> machine with 4G EPC reported by the kernel log and reproduced the  
> failures only on 5th run for both 4G and 8G size requests (set by  
> edmm_size). The failure seems to stick for subsequent runs but I did not  
> run more than 7 times for each case so can't say definitely about that.
>

FYI I have ran more iterations, and there is no hysteresis. Failures are  
random on this platform.
Also I was able to reproduce the same random failures on V4 patches:  
https://github.com/rchatre/linux/commits/sgx/sgx2_submitted_v4_plus_rwx.

Another observation is that those failures are no reproduced when BIOS is  
configured with 64G EPC on each socket.

Failures with v4 were not reproduced on Vijay's machine even with 30 runs.

Note my CPU has a different microcode version from Vijay's though both are  
the same model:

processor       : 127
vendor_id       : GenuineIntel
cpu family      : 6
model           : 106
model name      : Intel(R) Xeon(R) Platinum 8352Y CPU @ 2.20GHz
stepping        : 6
microcode       : 0xd000363
cpu MHz         : 2200.000
cache size      : 49152 KB
physical id     : 1
siblings        : 64
core id         : 31
cpu cores       : 32
apicid          : 191
initial apicid  : 191
fpu             : yes
fpu_exception   : yes
cpuid level     : 27
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca  
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx  
pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl  
xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl  
vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2  
x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm  
abm 3dnowprefetch cpuid_fault epb cat_l3 invpcid_single intel_ppin ssbd  
mba ibrs ibpb stibp ibrs_enhanced tpr_shadow vnmi flexpriority ept vpid  
ept_ad fsgsbase tsc_adjust sgx bmi1 avx2 smep bmi2 erms invpcid cqm rdt_a  
avx512f avx512dq rdseed adx smap avx512ifma clflushopt clwb intel_pt  
avx512cd sha_ni avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves cqm_llc  
cqm_occup_llc cqm_mbm_total cqm_mbm_local split_lock_detect wbnoinvd  
dtherm ida arat pln pts hwp hwp_act_window hwp_epp hwp_pkg_req avx512vbmi  
umip pku ospke avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni avx512_bitalg  
tme avx512_vpopcntdq rdpid sgx_lc fsrm md_clear pconfig flush_l1d  
arch_capabilities
vmx flags       : vnmi preemption_timer posted_intr invvpid ept_x_only  
ept_ad ept_1gb flexpriority apicv tsc_offset vtpr mtf vapic ept vpid  
unrestricted_guest vapic_reg vid ple shadow_vmcs pml ept_mode_based_exec  
tsc_scaling
bugs            : spectre_v1 spectre_v2 spec_store_bypass swapgs
bogomips        : 4402.06
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 57 bits virtual
power management:

Thanks
Haitao

>
>>
>>> -----Original Message-----
>>> From: Hansen, Dave <dave.hansen@intel.com>
>>> Sent: Friday, July 29, 2022 9:38 AM
>>> To: Dhanraj, Vijay <vijay.dhanraj@intel.com>; Chatre, Reinette
>>> <reinette.chatre@intel.com>; dave.hansen@linux.intel.com;
>>> jarkko@kernel.org; linux-sgx@vger.kernel.org
>>> Cc: Huang, Haitao <haitao.huang@intel.com>
>>> Subject: Re: Support SGX2 V5: Seg-fault with EACCEPT for large number  
>>> of
>>> EPC pages
>>>
>>> On 7/29/22 09:01, Dhanraj, Vijay wrote:
>>> > Huang, Haitao and I created a simple patch to repro this issue using  
>>> the SGX
>>> selftests and we do see the issue when using V5 (5.18.0-rc5) but cannot
>>> repro the issue in V4 (5.18.0-rc2). Not sure if this is a driver issue  
>>> or kernel,
>>> can you please check?
>>>
>>> Thanks for the report.
>>>
>>> Could you please try the code that's going to go to Linus shortly?   
>>> It's really
>>> the only version that matters at this point?
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/log/?h=x86/sgx
