Return-Path: <SRS0=OjbW=4B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E712CC2BA83
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Feb 2020 10:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A189324649
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Feb 2020 10:49:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="AguTaT5/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbgBMKtd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Feb 2020 05:49:33 -0500
Received: from mail-dm6nam12on2116.outbound.protection.outlook.com ([40.107.243.116]:16865
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726232AbgBMKtc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Feb 2020 05:49:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YW/PwMa52T0oYrIcDDZd7rlEfEcA/10wp1mkupv9S56ap/vubkShC/ulo1Ly6smdHUJSel/DlNATKh5gi+I5tm+Cqz8NQfQ6J67I7a3kLspdkaiWJ2+jSRR9CqgVkXmN4qLDIxT5ksX6IQV7z8Cw3TU6eEr1a6EIP9g1u82vDdLGlvVC5Rz/K0UWOiSgRiuNz9UBJUznBQLO09sPfSstwFniu4CqweKzQwtRPGG4MyVCCjvcL+4pnufP7cwqLdOKTeEi1yGvV5ymYnFHDdhgh36ce9rJSeRqjb+Naxhh0SqPGi5PFPz/ApYOL+N+1ryGLZyjxRjfzEPnnaJV2/Ggwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1Pde1onGSDd1PxjH1H32ne5Udn8C2FJsVfS3sYkU/E=;
 b=OozOi6oyrd8nvlA9MY+IqoUDR5e70RT3k7WOxY/dw+JiFty59ZEn6IplfrS8qfjlDiujQWOB462Ib7PR/fLWRl9VqPCPCTjYPdbNgHANIeJjaI2mv9Pu8U2Y3DdpoB7Tu9PHlEYSAC2N76UJ2eMPnb/8iITrfJOQxoVqjrMI2PNQ0KTG3Oh+BrLYtXDpoRz1TJyjl3h50r9uoufJYNf0qAJna+3ZGxz+fKNMz9R8BwePxFJRObqwbmaQxEBPNhSYnZAYTJoBBiFq8xWDBNc0FMEoheSIuY5/xiF+wVs1IeLxnxhsBzO2N56/hywCHnnIZbkHf3uLVOzYFbhF2jL0Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1Pde1onGSDd1PxjH1H32ne5Udn8C2FJsVfS3sYkU/E=;
 b=AguTaT5/bzgv7ENfoEpw00Pz/vNeRz9N8J5TiU5NVYDQtn60kG5NQPjsAWVLPJzQkN4vJbP2KP8jxYzhrszXZwJvUFEbp4deq8RjJPwoSinoV8ziUE4sHd9pWd2We/KwwisVPAeqZITXi/iyhbu5I4BJ3SX2ejdScvMuhb8My6A=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (20.178.239.29) by
 BYAPR11MB2743.namprd11.prod.outlook.com (52.135.227.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Thu, 13 Feb 2020 10:49:27 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::180:d484:4d3f:fd99]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::180:d484:4d3f:fd99%7]) with mapi id 15.20.2729.025; Thu, 13 Feb 2020
 10:49:27 +0000
Subject: Re: [PATCH v26 13/22] x86/sgx: Add provisioning
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
 <20200209212609.7928-14-jarkko.sakkinen@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <91744cc7-b50c-ffe2-1875-aba9174f7535@fortanix.com>
Date:   Thu, 13 Feb 2020 11:49:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <20200209212609.7928-14-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LNXP265CA0078.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::18) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
Received: from [10.195.0.226] (212.61.132.179) by LNXP265CA0078.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:76::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Thu, 13 Feb 2020 10:49:23 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8d8335c-4733-4c13-7717-08d7b0726599
X-MS-TrafficTypeDiagnostic: BYAPR11MB2743:
X-Microsoft-Antispam-PRVS: <BYAPR11MB27430463C36AF47BDB950739AA1A0@BYAPR11MB2743.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(39830400003)(396003)(366004)(376002)(136003)(346002)(199004)(189003)(66476007)(86362001)(66946007)(31696002)(36756003)(52116002)(5660300002)(4326008)(6486002)(31686004)(26005)(316002)(508600001)(66556008)(53546011)(16576012)(16526019)(186003)(956004)(81156014)(7416002)(81166006)(8676002)(2906002)(8936002)(2616005)(6666004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB2743;H:BYAPR11MB3734.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hiNSRlLldMAHPIvzB+5xoMs6gFXxbQO/YJwJYRj6eX5TsxZCwXoB9MmbCHUaE6560W5rH02UV1U+yhkT1LjaKj7U008PMVkcqmehfxbOudf3tBJ+AT7UT/VNkFY8f3v8ZOcI5PVvaEFyJb9/k+Fo3NLyJBSBGxeOoCj9t+EvOaamm4f2SSqQ+af1a0nqLbGxwEp50lwk3T5QS5sHJ3fH1UEDvCfv3UUkUUxXFGbtQgBPIkNUDTxRtaL3hdY1o68GVoS4kmz+Bg5nTOPn9XEHxTX4A8EiZk6jdp2slkdNdrqtCTaNutE7HWnAZENEWClCBJxqBTCGJylmKZBkiH8wA9xHHOxez+5SFrGhpsDu/Ex0SJ+i5fUkkTkjrVcd08LHXnGzeI75X3VO4iaklPH8SGQfgl3/zrQHPCMVBkca8TSlH38NuZjjjHC5rf3xdzZ6
X-MS-Exchange-AntiSpam-MessageData: hYbdBlg7QSnNP8BokeXYkYFFcHTiCOHsFJXNSCkADRcdu3jQZn03PxcdRa7ItdqyHDLxQPR6mCL3jIjWh+JkkTpwtT9gayvOgTUO515fTLqGVHtC7mfmu8vMDIXzWwIAkMuZGtNsaQB7qLlgtOP5Jg==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8d8335c-4733-4c13-7717-08d7b0726599
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 10:49:27.7608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kpVITXddMKjM8owSmF4uMhtA3HnUCM3ulGdoUN8ubhQk2uIpOZBmURbme+7JatvUq1WIUIXMJiXzl0h23oOI4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2743
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This patch and 22/22 contain the following email header:

Content-Type: text/plain; charset=a

git am doesn't like this.

--
Jethro Beekman | Fortanix

On 2020-02-09 22:26, Jarkko Sakkinen wrote:
> In order to provide a mechanism for devilering provisoning rights:
> 
> 1. Add a new device file /dev/sgx/provision that works as a token for
>    allowing an enclave to have the provisioning privileges.
> 2. Add a new ioctl called SGX_IOC_ENCLAVE_SET_ATTRIBUTE that accepts the
>    following data structure:
> 
>    struct sgx_enclave_set_attribute {
>            __u64 addr;
>            __u64 attribute_fd;
>    };
> 
> A daemon could sit on top of /dev/sgx/provision and send a file
> descriptor of this file to a process that needs to be able to provision
> enclaves.
> 
> The way this API is used is straight-forward. Lets assume that dev_fd is
> a handle to /dev/sgx/enclave and prov_fd is a handle to
> /dev/sgx/provision.  You would allow SGX_IOC_ENCLAVE_CREATE to
> initialize an enclave with the PROVISIONKEY attribute by
> 
> params.addr = <enclave address>;
> params.token_fd = prov_fd;
> 
> ioctl(dev_fd, SGX_IOC_ENCLAVE_SET_ATTRIBUTE, &params);
> 
> Cc: linux-security-module@vger.kernel.org
> Suggested-by: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/include/uapi/asm/sgx.h  | 11 ++++++++
>  arch/x86/kernel/cpu/sgx/driver.c | 14 ++++++++++
>  arch/x86/kernel/cpu/sgx/driver.h |  2 ++
>  arch/x86/kernel/cpu/sgx/ioctl.c  | 47 ++++++++++++++++++++++++++++++++
>  4 files changed, 74 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> index 5edb08ab8fd0..57d0d30c79b3 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -25,6 +25,8 @@ enum sgx_page_flags {
>  	_IOWR(SGX_MAGIC, 0x01, struct sgx_enclave_add_pages)
>  #define SGX_IOC_ENCLAVE_INIT \
>  	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
> +#define SGX_IOC_ENCLAVE_SET_ATTRIBUTE \
> +	_IOW(SGX_MAGIC, 0x03, struct sgx_enclave_set_attribute)
>  
>  /**
>   * struct sgx_enclave_create - parameter structure for the
> @@ -63,4 +65,13 @@ struct sgx_enclave_init {
>  	__u64 sigstruct;
>  };
>  
> +/**
> + * struct sgx_enclave_set_attribute - parameter structure for the
> + *				      %SGX_IOC_ENCLAVE_SET_ATTRIBUTE ioctl
> + * @attribute_fd:	file handle of the attribute file in the securityfs
> + */
> +struct sgx_enclave_set_attribute {
> +	__u64 attribute_fd;
> +};
> +
>  #endif /* _UAPI_ASM_X86_SGX_H */
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> index b4aa7b9f8376..d90114cec1c3 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -150,6 +150,13 @@ static struct miscdevice sgx_dev_enclave = {
>  	.fops = &sgx_encl_fops,
>  };
>  
> +static struct miscdevice sgx_dev_provision = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = "provision",
> +	.nodename = "sgx/provision",
> +	.fops = &sgx_provision_fops,
> +};
> +
>  int __init sgx_drv_init(void)
>  {
>  	unsigned int eax, ebx, ecx, edx;
> @@ -190,5 +197,12 @@ int __init sgx_drv_init(void)
>  		return ret;
>  	}
>  
> +	ret = misc_register(&sgx_dev_provision);
> +	if (ret) {
> +		pr_err("Creating /dev/sgx/provision failed with %d.\n", ret);
> +		misc_deregister(&sgx_dev_enclave);
> +		return ret;
> +	}
> +
>  	return 0;
>  }
> diff --git a/arch/x86/kernel/cpu/sgx/driver.h b/arch/x86/kernel/cpu/sgx/driver.h
> index e4063923115b..72747d01c046 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.h
> +++ b/arch/x86/kernel/cpu/sgx/driver.h
> @@ -23,6 +23,8 @@ extern u64 sgx_attributes_reserved_mask;
>  extern u64 sgx_xfrm_reserved_mask;
>  extern u32 sgx_xsave_size_tbl[64];
>  
> +extern const struct file_operations sgx_provision_fops;
> +
>  long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
>  
>  int sgx_drv_init(void);
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 83513cdfd1c0..262001df3ae4 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -663,6 +663,50 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
>  	return ret;
>  }
>  
> +/**
> + * sgx_ioc_enclave_set_attribute - handler for %SGX_IOC_ENCLAVE_SET_ATTRIBUTE
> + * @filep:	open file to /dev/sgx
> + * @arg:	userspace pointer to a struct sgx_enclave_set_attribute instance
> + *
> + * Mark the enclave as being allowed to access a restricted attribute bit.
> + * The requested attribute is specified via the attribute_fd field in the
> + * provided struct sgx_enclave_set_attribute.  The attribute_fd must be a
> + * handle to an SGX attribute file, e.g. “/dev/sgx/provision".
> + *
> + * Failure to explicitly request access to a restricted attribute will cause
> + * sgx_ioc_enclave_init() to fail.  Currently, the only restricted attribute
> + * is access to the PROVISION_KEY.
> + *
> + * Note, access to the EINITTOKEN_KEY is disallowed entirely.
> + *
> + * Return: 0 on success, -errno otherwise
> + */
> +static long sgx_ioc_enclave_set_attribute(struct sgx_encl *encl,
> +					  void __user *arg)
> +{
> +	struct sgx_enclave_set_attribute params;
> +	struct file *attribute_file;
> +	int ret;
> +
> +	if (copy_from_user(&params, arg, sizeof(params)))
> +		return -EFAULT;
> +
> +	attribute_file = fget(params.attribute_fd);
> +	if (!attribute_file)
> +		return -EINVAL;
> +
> +	if (attribute_file->f_op != &sgx_provision_fops) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	encl->allowed_attributes |= SGX_ATTR_PROVISIONKEY;
> +	ret = 0;
> +
> +out:
> +	fput(attribute_file);
> +	return ret;
> +}
>  
>  long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>  {
> @@ -686,6 +730,9 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>  	case SGX_IOC_ENCLAVE_INIT:
>  		ret = sgx_ioc_enclave_init(encl, (void __user *)arg);
>  		break;
> +	case SGX_IOC_ENCLAVE_SET_ATTRIBUTE:
> +		ret = sgx_ioc_enclave_set_attribute(encl, (void __user *)arg);
> +		break;
>  	default:
>  		ret = -ENOIOCTLCMD;
>  		break;
> 
